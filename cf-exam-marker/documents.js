/**
 * documents.js — Generic document CRUD (math, chemistry, etc.)
 * Content in R2, metadata in D1.
 * Anonymous create allowed; owner or edit_token for update/delete.
 */

const MAX_CONTENT_SIZE = 1024 * 1024; // 1MB
const VALID_DOC_TYPES = new Set(['math', 'chemistry', 'generic']);
const VALID_VISIBILITY = new Set(['public', 'private', 'unlisted']);

function jsonResponse(body, init = {}) {
  return new Response(JSON.stringify(body), {
    headers: { 'content-type': 'application/json; charset=utf-8' },
    ...init,
  });
}

function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

function generateEditToken() {
  const bytes = new Uint8Array(24);
  crypto.getRandomValues(bytes);
  return Array.from(bytes, (b) => b.toString(16).padStart(2, '0')).join('');
}

async function hashToken(token) {
  const data = new TextEncoder().encode(token);
  const hash = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(hash))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

async function verifyEditToken(provided, storedHash) {
  if (!provided || !storedHash) return false;
  const hash = await hashToken(provided);
  return hash === storedHash;
}

function r2Key(id) {
  return `docs/${id}`;
}

/**
 * POST /api/documents — Create document (no auth required)
 */
export async function handleCreateDocument(request, env) {
  const apiKeyError = requireApiKey(request, env);
  if (apiKeyError) return apiKeyError;

  const userId = request.headers.get('x-user-id') || null;

  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const { title, content, doc_type, visibility, content_type } = payload;

  if (!content || typeof content !== 'string') {
    return jsonResponse({ error: 'Missing or invalid content' }, { status: 400 });
  }

  if (content.length > MAX_CONTENT_SIZE) {
    return jsonResponse({ error: 'Content too large (max 1MB)' }, { status: 400 });
  }

  const docType = VALID_DOC_TYPES.has(doc_type) ? doc_type : 'generic';
  const vis = VALID_VISIBILITY.has(visibility) ? visibility : 'private';
  const ct = content_type === 'json' ? 'json' : 'html';

  const id = generateUUID();
  const r2KeyVal = r2Key(id);
  const now = new Date().toISOString();

  let editToken = null;
  let editTokenHash = null;
  if (!userId) {
    editToken = generateEditToken();
    editTokenHash = await hashToken(editToken);
  }

  // Store content in R2
  if (env.DOCUMENTS) {
    await env.DOCUMENTS.put(r2KeyVal, content, {
      httpMetadata: { contentType: ct === 'json' ? 'application/json' : 'text/html' },
      customMetadata: { updated_at: now },
    });
  }

  // Insert metadata in D1
  if (env.DB) {
    await env.DB.prepare(
      `INSERT INTO documents (id, user_id, doc_type, title, visibility, r2_key, content_type, edit_token_hash, created_at, updated_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
    )
      .bind(
        id,
        userId,
        docType,
        (title || 'Untitled').toString().slice(0, 500),
        vis,
        r2KeyVal,
        ct,
        editTokenHash,
        now,
        now
      )
      .run();
  }

  const doc = {
    id,
    title: title || 'Untitled',
    doc_type: docType,
    visibility: vis,
    created_at: now,
    updated_at: now,
  };
  if (editToken) doc.edit_token = editToken;

  return jsonResponse({ success: true, document: doc }, { status: 201 });
}

/**
 * GET /api/documents/:id — Get document (public/unlisted: anyone; private: owner or token)
 */
export async function handleGetDocument(id, request, env) {
  const apiKeyError = requireApiKey(request, env);
  if (apiKeyError) return apiKeyError;

  const tokenParam = new URL(request.url).searchParams.get('token');
  const userId = request.headers.get('x-user-id') || null;
  const editToken = request.headers.get('x-edit-token') || tokenParam;

  if (!env.DB) {
    return jsonResponse({ error: 'Database not configured' }, { status: 500 });
  }

  const row = await env.DB.prepare(
    'SELECT id, user_id, doc_type, title, visibility, r2_key, content_type, created_at, updated_at, edit_token_hash FROM documents WHERE id = ?'
  )
    .bind(id)
    .first();

  if (!row) {
    return jsonResponse({ error: 'Document not found' }, { status: 404 });
  }

  if (row.visibility === 'private') {
    const isOwner = userId && row.user_id === userId;
    const hasValidToken = row.edit_token_hash && (await verifyEditToken(editToken, row.edit_token_hash));
    if (!isOwner && !hasValidToken) {
      return jsonResponse({ error: 'Access denied' }, { status: 403 });
    }
  }

  let content = '';
  if (env.DOCUMENTS) {
    const obj = await env.DOCUMENTS.get(row.r2_key);
    content = obj ? await obj.text() : '';
  }

  return jsonResponse({
    success: true,
    document: {
      id: row.id,
      title: row.title,
      doc_type: row.doc_type,
      content,
      visibility: row.visibility,
      content_type: row.content_type,
      created_at: row.created_at,
      updated_at: row.updated_at,
      owned_by_me: !!userId && row.user_id === userId,
    },
  });
}

/**
 * PUT /api/documents/:id — Update document (owner or edit_token)
 */
export async function handleUpdateDocument(id, request, env) {
  const apiKeyError = requireApiKey(request, env);
  if (apiKeyError) return apiKeyError;

  const userId = request.headers.get('x-user-id') || null;
  const editToken = request.headers.get('x-edit-token') || null;

  if (!env.DB) {
    return jsonResponse({ error: 'Database not configured' }, { status: 500 });
  }

  const row = await env.DB.prepare(
    'SELECT id, user_id, r2_key, edit_token_hash FROM documents WHERE id = ?'
  )
    .bind(id)
    .first();

  if (!row) {
    return jsonResponse({ error: 'Document not found' }, { status: 404 });
  }

  const isOwner = userId && row.user_id === userId;
  const hasValidToken = row.edit_token_hash && (await verifyEditToken(editToken, row.edit_token_hash));

  if (!isOwner && !hasValidToken) {
    return jsonResponse({ error: 'Access denied' }, { status: 403 });
  }

  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const { title, content, visibility } = payload;
  const updates = [];
  const values = [];
  const now = new Date().toISOString();

  // Claim flow: anonymous doc (user_id=null) + valid edit_token + X-User-Id → set owner
  // Only when doc has no owner; never allow ownership transfer of owned docs
  if (row.user_id === null && hasValidToken && userId) {
    updates.push('user_id = ?');
    values.push(userId);
  }

  if (title !== undefined) {
    updates.push('title = ?');
    values.push(title.toString().slice(0, 500));
  }
  if (visibility !== undefined && VALID_VISIBILITY.has(visibility)) {
    updates.push('visibility = ?');
    values.push(visibility);
  }

  updates.push('updated_at = ?');
  values.push(now);
  values.push(id);

  if (content !== undefined) {
    if (typeof content !== 'string') {
      return jsonResponse({ error: 'Invalid content' }, { status: 400 });
    }
    if (content.length > MAX_CONTENT_SIZE) {
      return jsonResponse({ error: 'Content too large (max 1MB)' }, { status: 400 });
    }

    if (env.DOCUMENTS) {
      const ct = row.content_type === 'json' ? 'application/json' : 'text/html';
      await env.DOCUMENTS.put(row.r2_key, content, {
        httpMetadata: { contentType: ct },
        customMetadata: { updated_at: now },
      });
    }
  }

  if (updates.length > 1) {
    await env.DB.prepare(
      `UPDATE documents SET ${updates.join(', ')} WHERE id = ?`
    )
      .bind(...values)
      .run();
  }

  const updated = await env.DB.prepare(
    'SELECT id, user_id, title, doc_type, visibility, updated_at FROM documents WHERE id = ?'
  )
    .bind(id)
    .first();

  return jsonResponse({
    success: true,
    document: updated,
  });
}

/**
 * DELETE /api/documents/:id — Delete document (owner or edit_token)
 */
export async function handleDeleteDocument(id, request, env) {
  const apiKeyError = requireApiKey(request, env);
  if (apiKeyError) return apiKeyError;

  const userId = request.headers.get('x-user-id') || null;
  const editToken = request.headers.get('x-edit-token') || null;

  if (!env.DB) {
    return jsonResponse({ error: 'Database not configured' }, { status: 500 });
  }

  const row = await env.DB.prepare(
    'SELECT user_id, r2_key, edit_token_hash FROM documents WHERE id = ?'
  )
    .bind(id)
    .first();

  if (!row) {
    return jsonResponse({ error: 'Document not found' }, { status: 404 });
  }

  const isOwner = userId && row.user_id === userId;
  const hasValidToken = row.edit_token_hash && (await verifyEditToken(editToken, row.edit_token_hash));

  if (!isOwner && !hasValidToken) {
    return jsonResponse({ error: 'Access denied' }, { status: 403 });
  }

  if (env.DOCUMENTS) {
    await env.DOCUMENTS.delete(row.r2_key);
  }

  await env.DB.prepare('DELETE FROM documents WHERE id = ?').bind(id).run();

  return jsonResponse({ success: true, deleted: true });
}

/**
 * GET /api/documents — List documents (filter by user_id, doc_type, visibility)
 */
export async function handleListDocuments(request, env) {
  const apiKeyError = requireApiKey(request, env);
  if (apiKeyError) return apiKeyError;

  const userId = request.headers.get('x-user-id') || null;
  const url = new URL(request.url);
  const filterUserId = url.searchParams.get('user_id');
  const docType = url.searchParams.get('doc_type');
  const visibility = url.searchParams.get('visibility');
  const sortParam = url.searchParams.get('sort') || 'updated_at';
  const sortColumn = sortParam === 'created_at' ? 'created_at' : 'updated_at';
  const limit = Math.min(parseInt(url.searchParams.get('limit')) || 50, 100);
  const offset = Math.max(0, parseInt(url.searchParams.get('offset')) || 0);

  if (!env.DB) {
    return jsonResponse({ error: 'Database not configured' }, { status: 500 });
  }

  // List "my docs": user_id filter must match caller
  if (filterUserId && filterUserId !== userId) {
    return jsonResponse({ error: 'Access denied' }, { status: 403 });
  }

  let query = 'SELECT id, title, doc_type, visibility, created_at, updated_at FROM documents WHERE 1=1';
  const params = [];

  if (filterUserId) {
    query += ' AND user_id = ?';
    params.push(filterUserId);
  } else if (userId) {
    // No filter: only return caller's docs (don't leak others' private docs)
    query += ' AND user_id = ?';
    params.push(userId);
  } else {
    // Anonymous caller: only public docs
    query += ' AND visibility = ?';
    params.push('public');
  }

  if (docType && VALID_DOC_TYPES.has(docType)) {
    query += ' AND doc_type = ?';
    params.push(docType);
  }

  if (visibility && VALID_VISIBILITY.has(visibility)) {
    query += ' AND visibility = ?';
    params.push(visibility);
  }

  query += ` ORDER BY ${sortColumn} DESC LIMIT ? OFFSET ?`;
  params.push(limit, offset);

  const result = await env.DB.prepare(query).bind(...params).all();

  // Get total count (same filters, no pagination)
  let countQuery = 'SELECT COUNT(*) as total FROM documents WHERE 1=1';
  const countParams = [];
  if (filterUserId) {
    countQuery += ' AND user_id = ?';
    countParams.push(filterUserId);
  } else if (userId) {
    countQuery += ' AND user_id = ?';
    countParams.push(userId);
  } else {
    countQuery += ' AND visibility = ?';
    countParams.push('public');
  }
  if (docType && VALID_DOC_TYPES.has(docType)) {
    countQuery += ' AND doc_type = ?';
    countParams.push(docType);
  }
  if (visibility && VALID_VISIBILITY.has(visibility)) {
    countQuery += ' AND visibility = ?';
    countParams.push(visibility);
  }
  const countRow = await env.DB.prepare(countQuery).bind(...countParams).first();

  return jsonResponse({
    success: true,
    documents: result.results,
    total: countRow?.total ?? 0,
    limit,
    offset,
  });
}

function requireApiKey(request, env) {
  if (!env.API_KEY) {
    return jsonResponse({ error: 'API key not configured' }, { status: 500 });
  }
  const provided = request.headers.get('x-api-key');
  if (!provided || provided !== env.API_KEY) {
    return jsonResponse({ error: 'Unauthorized' }, { status: 401 });
  }
  return null;
}
