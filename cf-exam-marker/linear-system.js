// Linear System AI prompt builder for math-steps
// Handles step-by-step explanations for various solving methods

/**
 * Build a linear-system-specific prompt for OpenAI step-by-step solutions.
 *
 * @param {string} equations - The system of equations (one per line)
 * @param {string} method    - Solving method used (gaussian, gauss_jordan, lu, cramer, inverse, least_squares)
 * @param {string} answer    - Known answer if available
 * @returns {string} The prompt string
 */
export function buildLinearSystemPrompt(equations, method, answer) {
  const hasAnswer = answer && answer !== 'unknown';

  const methodName = {
    gaussian: 'Gaussian Elimination',
    gauss_jordan: 'Gauss-Jordan Elimination (RREF)',
    lu: 'LU Decomposition',
    cramer: "Cramer's Rule",
    inverse: 'Matrix Inverse Method',
    least_squares: 'Least Squares Method'
  }[method] || 'Gaussian Elimination';

  let methodRules;

  switch (method) {
    case 'gaussian':
      methodRules = `- Write the augmented matrix [A | b]
- Perform row operations to reach row echelon form (REF)
- Use partial pivoting: swap rows to put largest pivot on diagonal
- For each pivot column: eliminate entries below the pivot using row operations R_i = R_i - (factor)*R_pivot
- Show the augmented matrix after each elimination step
- Back-substitute from the last row upward to find each variable
- State the solution vector clearly`;
      break;

    case 'gauss_jordan':
      methodRules = `- Write the augmented matrix [A | b]
- Perform row operations to reach reduced row echelon form (RREF)
- Scale each pivot to 1, then eliminate both above AND below
- Show the augmented matrix after each step
- Read the solution directly from the RREF (each row gives one variable)
- State the solution vector clearly`;
      break;

    case 'lu':
      methodRules = `- Factor A = LU where L is lower triangular and U is upper triangular
- Show the elimination steps that produce L and U
- Forward substitution: solve Ly = b for y
- Back substitution: solve Ux = y for x
- Show each step of both substitution phases
- State the solution vector clearly`;
      break;

    case 'cramer':
      methodRules = `- Compute det(A) - the determinant of the coefficient matrix
- For each variable x_i, form matrix A_i by replacing column i of A with vector b
- Compute det(A_i) for each i
- Apply Cramer's formula: x_i = det(A_i) / det(A)
- Show each determinant computation step by step
- State the solution vector clearly`;
      break;

    case 'inverse':
      methodRules = `- Compute A^{-1} using the augmented matrix [A | I] → [I | A^{-1}]
- Show the row operations to transform A to I
- Multiply: x = A^{-1} * b
- Show the matrix-vector multiplication
- State the solution vector clearly`;
      break;

    case 'least_squares':
      methodRules = `- This is an overdetermined system (more equations than unknowns)
- Form the normal equations: A^T A x = A^T b
- Compute A^T (transpose of A)
- Compute A^T A (the normal matrix)
- Compute A^T b (the normal vector)
- Solve the normal equations for x
- Compute the residual ||Ax - b|| to show quality of fit
- State the least squares solution clearly`;
      break;

    default:
      methodRules = `- Identify the system type (square, overdetermined, underdetermined)
- Choose appropriate method based on the system
- Show each step of the solution process
- State the solution clearly`;
  }

  let problemDesc = hasAnswer
    ? `Solve the linear system using ${methodName}. The answer is ${answer}.`
    : `Solve the linear system using ${methodName}.`;

  return `Show detailed solution steps for: ${problemDesc}

System of equations:
${equations}

Method: ${methodName}

Rules:
- Give 5-10 clear steps. Do NOT skip intermediate algebra or row operations.
- Step 1: Write the system in matrix form Ax = b, showing A and b explicitly
- Step 2: Begin the ${methodName} procedure
${methodRules}
- Each step: short descriptive title + full LaTeX formula showing the work
- Use \\begin{bmatrix} for matrices, \\begin{array} for augmented matrices
- Use \\left[\\begin{array}{ccc|c} for augmented matrix notation
- Show row operation labels like R_2 = R_2 - 3R_1
- LaTeX must use \\frac{}{}, \\begin{bmatrix}, \\left(, \\right) etc.
- JSON only, no explanation text outside the JSON

Response format:
{"steps":[{"t":"step title","l":"LaTeX formula"}],"method":"${methodName}"}`;
}
