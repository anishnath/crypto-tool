"""
worksheet_figure_gen — SVG figure generation for worksheet questions.

Generates lightweight, print-friendly SVG figures using matplotlib.
Figures are transparent-background, dark-mode invertible, and target <8KB each.

Usage:
    from worksheet_figure_gen import fig_secant_line, save_svg
    svg_path = fig_secant_line(expr, x, a_val=1, x_val=2, out_dir="figures/limits", qid=42)
"""

import re
import os
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_agg import FigureCanvasAgg

import sympy as sp

# ---------------------------------------------------------------------------
# Color palette — print-friendly, dark-mode invertible via CSS filter
# ---------------------------------------------------------------------------
C_CURVE      = '#2563eb'   # primary blue
C_CURVE2     = '#dc2626'   # red (second curve)
C_SECANT     = '#f59e0b'   # amber  (secant / tangent lines)
C_TANGENT    = '#16a34a'   # green
C_POINT      = '#111827'   # near-black dots
C_FILL       = '#2563eb'   # fill color (with alpha)
C_FILL_ALPHA = 0.15
C_ASYMPTOTE  = '#ef4444'   # red dashed
C_BOUND      = '#6b7280'   # gray for bounds / squeeze
C_GRID       = '#e5e7eb'
C_AXIS       = '#9ca3af'

FIGSIZE  = (3.5, 2.5)
DPI      = 72
N_POINTS = 80
N_FILL   = 50  # fewer points for fill_between (less path data)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _create_fig():
    """Create a transparent matplotlib Figure with standard styling."""
    fig = Figure(figsize=FIGSIZE, dpi=DPI, facecolor='none')
    canvas = FigureCanvasAgg(fig)
    ax = fig.add_subplot(111)
    ax.set_facecolor('none')
    ax.grid(True, color=C_GRID, linewidth=0.5, alpha=0.6)
    ax.tick_params(colors=C_AXIS, labelsize=7)
    for spine in ax.spines.values():
        spine.set_color(C_AXIS)
        spine.set_linewidth(0.6)
    # Reduce tick count to keep SVG small
    ax.locator_params(axis='both', nbins=5)
    return fig, ax


def _safe_eval(expr, var, x_arr):
    """Evaluate a SymPy expression over a numpy array, masking invalid values."""
    f_np = sp.lambdify(var, expr, modules=['numpy'])
    with np.errstate(divide='ignore', invalid='ignore', over='ignore'):
        y = np.array(f_np(x_arr), dtype=float)
    # Broadcast scalar/0-d results to match input shape
    if y.ndim == 0:
        y = np.full_like(x_arr, float(y), dtype=float)
    # Replace inf/nan with nan for clean plotting
    y[~np.isfinite(y)] = np.nan
    return y


def _postprocess_svg(svg_bytes):
    """Strip metadata, comments, and collapse whitespace for smaller SVGs."""
    text = svg_bytes.decode('utf-8') if isinstance(svg_bytes, bytes) else svg_bytes
    # Remove XML comments
    text = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)
    # Remove <metadata>...</metadata>
    text = re.sub(r'<metadata>.*?</metadata>', '', text, flags=re.DOTALL)
    # Remove <desc>...</desc>
    text = re.sub(r'<desc>.*?</desc>', '', text, flags=re.DOTALL)
    # Remove style blocks (we use inline styles via matplotlib)
    text = re.sub(r'<defs>\s*<style[^>]*>.*?</style>\s*</defs>', '', text, flags=re.DOTALL)
    # Remove <defs> if now empty
    text = re.sub(r'<defs>\s*</defs>', '', text)
    # Remove id attributes (not needed for inline SVGs)
    text = re.sub(r' id="[^"]*"', '', text)
    # Remove clip-path references and definitions for simpler output
    text = re.sub(r' clip-path="[^"]*"', '', text)
    text = re.sub(r'<clipPath[^>]*>.*?</clipPath>', '', text, flags=re.DOTALL)
    # Truncate coordinate precision to 2 decimal places
    def _trunc_coords(m):
        return f'{float(m.group(0)):.2f}'
    text = re.sub(r'\d+\.\d{3,}', _trunc_coords, text)
    # Collapse multiple whitespace / blank lines
    text = re.sub(r'\n\s*\n', '\n', text)
    text = re.sub(r'  +', ' ', text)
    return text.strip()


def save_svg(fig, out_dir, filename):
    """Save figure as optimized SVG, return relative path from webapp root."""
    os.makedirs(out_dir, exist_ok=True)
    full_path = os.path.join(out_dir, filename)

    from io import BytesIO
    buf = BytesIO()
    # Use text as <text> elements, not paths — dramatically smaller SVGs
    matplotlib.rcParams['svg.fonttype'] = 'none'
    fig.savefig(buf, format='svg', bbox_inches='tight', transparent=True,
                pad_inches=0.1)
    buf.seek(0)
    svg_text = _postprocess_svg(buf.read())

    with open(full_path, 'w', encoding='utf-8') as f:
        f.write(svg_text)

    plt.close(fig)

    # Return path relative to webapp root
    idx = full_path.find('worksheet/')
    if idx >= 0:
        return full_path[idx:]
    return full_path


def _auto_ylim(y_arr, margin=0.3):
    """Compute reasonable y-limits, clipping outliers."""
    valid = y_arr[np.isfinite(y_arr)]
    if len(valid) == 0:
        return (-5, 5)
    q1, q3 = np.percentile(valid, [5, 95])
    iqr = q3 - q1
    if iqr < 0.1:
        iqr = max(abs(q1), abs(q3), 1)
    lo = q1 - margin * iqr
    hi = q3 + margin * iqr
    # Clamp to reasonable range
    lo = max(lo, -50)
    hi = min(hi, 50)
    if hi - lo < 1:
        mid = (hi + lo) / 2
        lo, hi = mid - 1, mid + 1
    return (lo, hi)


# ---------------------------------------------------------------------------
# Template functions
# ---------------------------------------------------------------------------

def fig_secant_line(expr, var, a_val, x_val, out_dir, qid):
    """
    Draw f(x) with secant line between (a, f(a)) and (x_val, f(x_val)).
    """
    fig, ax = _create_fig()

    a_f = float(expr.subs(var, a_val))
    x_f = float(expr.subs(var, x_val))
    a_num = float(a_val)
    x_num = float(x_val)

    # Plot range centered on the two points
    pad = max(abs(x_num - a_num) * 2, 3)
    lo = min(a_num, x_num) - pad
    hi = max(a_num, x_num) + pad
    xs = np.linspace(lo, hi, N_POINTS)
    ys = _safe_eval(expr, var, xs)

    ylim = _auto_ylim(ys)
    ax.set_ylim(ylim)

    # Curve
    ax.plot(xs, ys, color=C_CURVE, linewidth=1.5, label='f(x)')

    # Secant line
    slope = (x_f - a_f) / (x_num - a_num) if x_num != a_num else 0
    sec_xs = np.linspace(lo, hi, 2)
    sec_ys = a_f + slope * (sec_xs - a_num)
    ax.plot(sec_xs, sec_ys, color=C_SECANT, linewidth=1.2, linestyle='--',
            label='Secant')

    # Points
    ax.plot(a_num, a_f, 'o', color=C_POINT, markersize=5, zorder=5)
    ax.plot(x_num, x_f, 'o', color=C_POINT, markersize=5, zorder=5)
    ax.annotate(f'({a_num:.4g}, {a_f:.4g})', (a_num, a_f),
                textcoords="offset points", xytext=(5, 8),
                fontsize=6, color=C_POINT)
    ax.annotate(f'({x_num:.4g}, {x_f:.4g})', (x_num, x_f),
                textcoords="offset points", xytext=(5, -12),
                fontsize=6, color=C_POINT)

    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'secant_slope_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def fig_tangent_line(expr, var, a_val, out_dir, qid):
    """
    Draw f(x) with tangent line at x = a.
    """
    fig, ax = _create_fig()

    a_num = float(a_val)
    a_f = float(expr.subs(var, a_val))
    deriv = sp.diff(expr, var)
    m = float(deriv.subs(var, a_val))

    pad = 4
    lo, hi = a_num - pad, a_num + pad
    xs = np.linspace(lo, hi, N_POINTS)
    ys = _safe_eval(expr, var, xs)

    ylim = _auto_ylim(ys)
    ax.set_ylim(ylim)

    ax.plot(xs, ys, color=C_CURVE, linewidth=1.5, label='f(x)')

    # Tangent line
    tan_xs = np.linspace(a_num - pad * 0.7, a_num + pad * 0.7, 2)
    tan_ys = a_f + m * (tan_xs - a_num)
    ax.plot(tan_xs, tan_ys, color=C_TANGENT, linewidth=1.2, linestyle='--',
            label='Tangent')

    ax.plot(a_num, a_f, 'o', color=C_POINT, markersize=5, zorder=5)
    ax.annotate(f'x = {a_num:.4g}', (a_num, a_f),
                textcoords="offset points", xytext=(5, 8),
                fontsize=6, color=C_POINT)

    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'tangent_line_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def fig_vertical_asymptote(expr, var, a_val, direction, out_dir, qid):
    """
    Draw f(x) near a vertical asymptote at x = a.
    """
    fig, ax = _create_fig()

    a_num = float(a_val)
    pad = 4
    lo, hi = a_num - pad, a_num + pad

    # Split at asymptote to avoid connecting across infinity
    eps = 0.05
    xs_left = np.linspace(lo, a_num - eps, N_POINTS // 2)
    xs_right = np.linspace(a_num + eps, hi, N_POINTS // 2)

    ys_left = _safe_eval(expr, var, xs_left)
    ys_right = _safe_eval(expr, var, xs_right)

    # Clip y values
    all_y = np.concatenate([ys_left[np.isfinite(ys_left)],
                            ys_right[np.isfinite(ys_right)]])
    if len(all_y) > 0:
        ylim = _auto_ylim(all_y, margin=0.5)
    else:
        ylim = (-10, 10)
    ax.set_ylim(ylim)

    ax.plot(xs_left, ys_left, color=C_CURVE, linewidth=1.5)
    ax.plot(xs_right, ys_right, color=C_CURVE, linewidth=1.5)

    # Asymptote line
    ax.axvline(a_num, color=C_ASYMPTOTE, linewidth=1, linestyle=':', alpha=0.8)
    ax.annotate(f'x = {a_num:.4g}', (a_num, ylim[1] * 0.85),
                fontsize=6, color=C_ASYMPTOTE, ha='left',
                xytext=(4, 0), textcoords="offset points")

    # Arrow indicating direction
    if direction == '+':
        ax.annotate('', xy=(a_num + eps * 2, ylim[1] * 0.7),
                    xytext=(a_num + pad * 0.3, ylim[1] * 0.3),
                    arrowprops=dict(arrowstyle='->', color=C_SECANT, lw=1))
    elif direction == '-':
        ax.annotate('', xy=(a_num - eps * 2, ylim[1] * 0.7),
                    xytext=(a_num - pad * 0.3, ylim[1] * 0.3),
                    arrowprops=dict(arrowstyle='->', color=C_SECANT, lw=1))

    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'vertical_asymptote_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def fig_piecewise_continuity(left_expr, right_expr, var, a_val, out_dir, qid):
    """
    Draw a piecewise function with a gap/join at x = a.
    """
    fig, ax = _create_fig()

    a_num = float(a_val)
    pad = 4
    xs_left = np.linspace(a_num - pad, a_num - 0.01, N_POINTS // 2)
    xs_right = np.linspace(a_num, a_num + pad, N_POINTS // 2)

    ys_left = _safe_eval(left_expr, var, xs_left)
    ys_right = _safe_eval(right_expr, var, xs_right)

    all_y = np.concatenate([ys_left[np.isfinite(ys_left)],
                            ys_right[np.isfinite(ys_right)]])
    if len(all_y) > 0:
        ylim = _auto_ylim(all_y)
    else:
        ylim = (-5, 5)
    ax.set_ylim(ylim)

    ax.plot(xs_left, ys_left, color=C_CURVE, linewidth=1.5, label='x < a')
    ax.plot(xs_right, ys_right, color=C_CURVE2, linewidth=1.5, label='x >= a')

    # Open/closed circles at the join
    try:
        left_val = float(sp.limit(left_expr, var, a_val, '-'))
        if np.isfinite(left_val):
            ax.plot(a_num, left_val, 'o', color=C_CURVE, markersize=5,
                    markerfacecolor='white', markeredgewidth=1.5, zorder=5)
    except Exception:
        pass
    try:
        right_val = float(right_expr.subs(var, a_val))
        if np.isfinite(right_val):
            ax.plot(a_num, right_val, 'o', color=C_CURVE2, markersize=5, zorder=5)
    except Exception:
        pass

    ax.axvline(a_num, color=C_GRID, linewidth=0.8, linestyle=':')
    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'piecewise_continuity_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def fig_ivt(expr, var, a_val, b_val, out_dir, qid):
    """
    Draw f(x) on [a,b] showing sign change (IVT).
    """
    fig, ax = _create_fig()

    a_num, b_num = float(a_val), float(b_val)
    pad = (b_num - a_num) * 0.5
    lo, hi = a_num - pad, b_num + pad
    xs = np.linspace(lo, hi, N_POINTS)
    ys = _safe_eval(expr, var, xs)

    ylim = _auto_ylim(ys)
    ax.set_ylim(ylim)

    ax.plot(xs, ys, color=C_CURVE, linewidth=1.5)

    # Horizontal line at y=0
    ax.axhline(0, color=C_AXIS, linewidth=0.6, linestyle='-')

    # Shade the interval
    xs_interval = np.linspace(a_num, b_num, N_FILL)
    ys_interval = _safe_eval(expr, var, xs_interval)
    ax.fill_between(xs_interval, 0, ys_interval, alpha=C_FILL_ALPHA,
                    color=C_FILL)

    # Mark endpoints
    fa = float(expr.subs(var, a_val))
    fb = float(expr.subs(var, b_val))
    ax.plot(a_num, fa, 'o', color=C_POINT, markersize=5, zorder=5)
    ax.plot(b_num, fb, 'o', color=C_POINT, markersize=5, zorder=5)
    ax.annotate(f'f(a)={fa:.3g}', (a_num, fa),
                textcoords="offset points", xytext=(-5, 8),
                fontsize=6, color=C_POINT, ha='right')
    ax.annotate(f'f(b)={fb:.3g}', (b_num, fb),
                textcoords="offset points", xytext=(5, 8),
                fontsize=6, color=C_POINT)

    # Vertical lines at a, b
    ax.axvline(a_num, color=C_BOUND, linewidth=0.6, linestyle=':')
    ax.axvline(b_num, color=C_BOUND, linewidth=0.6, linestyle=':')

    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'ivt_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def fig_area_under_curve(expr, var, lo_val, hi_val, out_dir, qid,
                         expr2=None):
    """
    Draw area under f(x) (or between f and g) on [lo, hi].
    If expr2 is given, shade area between the two curves.
    """
    fig, ax = _create_fig()

    lo_num, hi_num = float(lo_val), float(hi_val)
    pad = (hi_num - lo_num) * 0.3
    x_lo, x_hi = lo_num - pad, hi_num + pad
    xs = np.linspace(x_lo, x_hi, N_POINTS)

    ys1 = _safe_eval(expr, var, xs)
    ax.plot(xs, ys1, color=C_CURVE, linewidth=1.5, label='f(x)')

    xs_fill = np.linspace(lo_num, hi_num, N_FILL)
    ys1_fill = _safe_eval(expr, var, xs_fill)

    if expr2 is not None:
        ys2 = _safe_eval(expr2, var, xs)
        ax.plot(xs, ys2, color=C_CURVE2, linewidth=1.5, label='g(x)')
        ys2_fill = _safe_eval(expr2, var, xs_fill)  # uses N_FILL points
        ax.fill_between(xs_fill, ys1_fill, ys2_fill,
                        alpha=C_FILL_ALPHA, color=C_FILL)
    else:
        ax.fill_between(xs_fill, 0, ys1_fill,
                        alpha=C_FILL_ALPHA, color=C_FILL)
        ax.axhline(0, color=C_AXIS, linewidth=0.6)

    all_y = ys1[np.isfinite(ys1)]
    if expr2 is not None:
        all_y = np.concatenate([all_y, ys2[np.isfinite(ys2)]])
    if len(all_y) > 0:
        ylim = _auto_ylim(all_y)
        ax.set_ylim(ylim)

    ax.axvline(lo_num, color=C_BOUND, linewidth=0.6, linestyle=':')
    ax.axvline(hi_num, color=C_BOUND, linewidth=0.6, linestyle=':')

    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'area_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def fig_squeeze_theorem(expr, var, out_dir, qid):
    """
    Draw f(x) squeezed between -|x|^n and |x|^n near 0.
    Expects expr of the form x^n * sin(c/x) or x^n * cos(c/x).
    """
    fig, ax = _create_fig()

    # Determine the power n from the expression
    # For x^n * trig(c/x), the bounds are -|x|^n and |x|^n
    # Try to extract n
    n = 2  # default
    try:
        terms = sp.Mul.make_args(expr)
        for term in terms:
            if term.is_Pow and term.base == var:
                n = int(term.exp)
                break
            elif term == var:
                n = 1
                break
    except Exception:
        pass

    xs = np.linspace(-1.5, 1.5, N_POINTS)
    ys = _safe_eval(expr, var, xs)

    # Bounds
    upper = np.abs(xs) ** n
    lower = -upper

    ylim = _auto_ylim(upper, margin=0.3)
    ax.set_ylim(-ylim[1] * 1.2, ylim[1] * 1.2)

    ax.plot(xs, upper, color=C_BOUND, linewidth=1, linestyle='--',
            alpha=0.7, label=f'|x|^{n}')
    ax.plot(xs, lower, color=C_BOUND, linewidth=1, linestyle='--',
            alpha=0.7, label=f'-|x|^{n}')
    ax.fill_between(xs, lower, upper, alpha=0.06, color=C_BOUND)
    ax.plot(xs, ys, color=C_CURVE, linewidth=1.5, label='f(x)')

    ax.plot(0, 0, 'o', color=C_TANGENT, markersize=6, zorder=5)
    ax.annotate('Limit = 0', (0, 0),
                textcoords="offset points", xytext=(8, 8),
                fontsize=7, color=C_TANGENT, fontweight='bold')

    ax.axhline(0, color=C_AXIS, linewidth=0.4)
    ax.axvline(0, color=C_AXIS, linewidth=0.4)
    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'squeeze_theorem_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def fig_graph_reading(graph_def, out_dir, qid):
    """
    Render a piecewise graph for graph-reading limit questions.
    Shows open/closed circles, isolated points, and vertical asymptotes.
    """
    fig = Figure(figsize=(4.5, 3.0), dpi=DPI, facecolor='none')
    canvas = FigureCanvasAgg(fig)
    ax = fig.add_subplot(111)
    ax.set_facecolor('none')

    domain = graph_def["domain"]
    x_lo, x_hi = domain

    # Integer grid — use only even ticks if domain is wide
    ax.set_xlim(x_lo - 0.5, x_hi + 0.5)
    x_ticks = list(range(int(x_lo), int(x_hi) + 1, 2))
    ax.set_xticks(x_ticks)
    ax.grid(True, color=C_GRID, linewidth=0.4, alpha=0.5)
    ax.tick_params(colors=C_AXIS, labelsize=7)
    for spine in ax.spines.values():
        spine.set_color(C_AXIS)
        spine.set_linewidth(0.5)
    ax.axhline(0, color=C_AXIS, linewidth=0.4)
    ax.axvline(0, color=C_AXIS, linewidth=0.4)

    # Collect all y-values for axis limits
    all_y = []

    # Draw vertical asymptotes first (behind curves)
    for sp_info in graph_def.get("special_points", []):
        if sp_info["disc_type"] == "infinite":
            ax.axvline(sp_info["x"], color=C_ASYMPTOTE, linewidth=1,
                       linestyle=':', alpha=0.8)

    # Light vertical reference lines at each special point
    for sp_info in graph_def.get("special_points", []):
        if sp_info["disc_type"] != "infinite":
            ax.axvline(sp_info["x"], color=C_GRID, linewidth=0.5,
                       linestyle=':', alpha=0.4)

    # Draw each segment
    x_sym = sp.Symbol('x')
    for seg in graph_def["segments"]:
        expr = seg["expr"]
        lo, hi = seg["interval"]
        xs = np.linspace(float(lo), float(hi), 25)
        ys = _safe_eval(expr, x_sym, xs)
        all_y.extend(ys[np.isfinite(ys)].tolist())
        ax.plot(xs, ys, color=C_CURVE, linewidth=1.8)

        # Endpoint markers
        for end_x, is_open, side in [(lo, seg["left_open"], "left"),
                                      (hi, seg["right_open"], "right")]:
            try:
                end_y = float(expr.subs(x_sym, end_x))
                if not np.isfinite(end_y):
                    continue
            except Exception:
                continue
            if is_open:
                ax.plot(float(end_x), end_y, 'o', markersize=6,
                        markerfacecolor='white', markeredgecolor=C_CURVE,
                        markeredgewidth=1.5, zorder=5)
            else:
                ax.plot(float(end_x), end_y, 'o', markersize=6,
                        color=C_CURVE, zorder=5)

    # Draw isolated points (removable discontinuity defined values)
    for pt in graph_def.get("isolated_points", []):
        ax.plot(pt["x"], pt["y"], 'o', markersize=6,
                color=C_CURVE, zorder=6)
        all_y.append(pt["y"])

    # Set y-limits from collected values
    if all_y:
        y_min = min(all_y) - 1.5
        y_max = max(all_y) + 1.5
        y_min = max(y_min, -7)
        y_max = min(y_max, 9)
    else:
        y_min, y_max = -6, 8
    ax.set_ylim(y_min, y_max)
    # Use every-other tick if range is wide to reduce SVG size
    y_range = list(range(int(np.ceil(y_min)), int(np.floor(y_max)) + 1))
    if len(y_range) > 10:
        y_range = [v for v in y_range if v % 2 == 0]
    ax.set_yticks(y_range)

    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'graph_reading_{qid:04d}.svg'
    return save_svg(fig, out_dir, fname)


# ---------------------------------------------------------------------------
# Mapping from question type to figure function
# ---------------------------------------------------------------------------

FIGURE_TYPES_LIMITS = {
    'secant_slope', 'tangent_line', 'vertical_asymptote',
    'piecewise_continuity', 'ivt_application', 'squeeze_theorem',
    'graph_limits_simple', 'graph_limits_full', 'graph_discontinuity',
}

FIGURE_TYPES_INTEGRALS = {
    'area_between_curves', 'riemann_sum', 'definite_standard',
}

FIGURE_TYPES_DERIVATIVES = {
    'tangent_line_eq', 'critical_points',
}


def generate_figure_for_limit(q_type, rec, entry_id, out_dir):
    """
    Generate a figure for a limits question if applicable.
    Returns the relative SVG path, or None.
    """
    if q_type not in FIGURE_TYPES_LIMITS:
        return None

    var = rec.get("var", sp.Symbol('x'))
    expr = rec.get("f")
    a_val = rec.get("a")

    try:
        if q_type == 'secant_slope':
            # Need x_val — extract from rec or skip
            # The generator stores a_val and the secant endpoint isn't in rec
            # We'll re-derive it: look for nearby point in the question
            # Simpler: just generate tangent-like figure at the point
            x_val = a_val + 1  # approximate
            return fig_secant_line(expr, var, a_val, x_val, out_dir, entry_id)

        elif q_type == 'tangent_line':
            return fig_tangent_line(expr, var, a_val, out_dir, entry_id)

        elif q_type == 'vertical_asymptote':
            direction = rec.get("dir", "+")
            return fig_vertical_asymptote(expr, var, a_val, direction,
                                          out_dir, entry_id)

        elif q_type == 'piecewise_continuity':
            # For piecewise, we need left and right expressions
            # The generator only stores left_expr in "f". We'll just plot
            # the left expression and note the join point.
            return fig_tangent_line(expr, var, a_val, out_dir, entry_id)

        elif q_type == 'ivt_application':
            # Need b_val — try to extract from question or use a+2
            b_val = a_val + 2
            return fig_ivt(expr, var, a_val, b_val, out_dir, entry_id)

        elif q_type == 'squeeze_theorem':
            return fig_squeeze_theorem(expr, var, out_dir, entry_id)

        elif q_type in ('graph_limits_simple', 'graph_limits_full',
                         'graph_discontinuity'):
            graph_def = rec.get("graph_def")
            if graph_def:
                return fig_graph_reading(graph_def, out_dir, entry_id)

    except Exception:
        return None

    return None


def generate_figure_for_integral(q_type, rec, entry_id, out_dir):
    """
    Generate a figure for an integrals question if applicable.
    Returns the relative SVG path, or None.
    """
    if q_type not in FIGURE_TYPES_INTEGRALS:
        return None

    var = sp.Symbol('x')
    expr = rec.get("integrand_expr")
    lo = rec.get("lo")
    hi = rec.get("hi")

    if expr is None or lo is None or hi is None:
        return None

    try:
        if q_type in ('definite_standard', 'riemann_sum'):
            return fig_area_under_curve(expr, var, lo, hi, out_dir, entry_id)

        elif q_type == 'area_between_curves':
            expr2 = rec.get("integrand_g")
            expr_f = rec.get("integrand_f", expr)
            return fig_area_under_curve(expr_f, var, lo, hi, out_dir, entry_id,
                                        expr2=expr2)

    except Exception:
        return None

    return None


def fig_critical_points(expr, var, out_dir, qid):
    """
    Plot f(x) and mark its critical points (where f'(x) = 0) with dots.
    """
    fig, ax = _create_fig()

    deriv = sp.diff(expr, var)
    try:
        crits = sp.solve(deriv, var)
        crits = [float(c) for c in crits if c.is_real]
    except Exception:
        crits = []

    if crits:
        lo = min(crits) - 3
        hi = max(crits) + 3
    else:
        lo, hi = -5, 5

    xs = np.linspace(lo, hi, N_POINTS)
    ys = _safe_eval(expr, var, xs)

    ylim = _auto_ylim(ys)
    ax.set_ylim(ylim)

    ax.plot(xs, ys, color=C_CURVE, linewidth=1.5, label='f(x)')

    # Mark critical points
    for c in crits:
        try:
            y_c = float(expr.subs(var, c))
            if ylim[0] <= y_c <= ylim[1]:
                ax.plot(c, y_c, 'o', color=C_POINT, markersize=5, zorder=5)
                ax.annotate(f'({c:.2g}, {y_c:.2g})', (c, y_c),
                            textcoords="offset points", xytext=(5, 8),
                            fontsize=5.5, color=C_POINT)
        except Exception:
            pass

    ax.set_xlabel('x', fontsize=7, color=C_AXIS)
    ax.set_ylabel('y', fontsize=7, color=C_AXIS)

    fname = f'critical_points_{qid:03d}.svg'
    return save_svg(fig, out_dir, fname)


def generate_figure_for_derivative(q_type, rec, entry_id, out_dir):
    """
    Generate a figure for a derivatives question if applicable.
    Returns the relative SVG path, or None.
    """
    if q_type not in FIGURE_TYPES_DERIVATIVES:
        return None

    var = rec.get("var", sp.Symbol('x'))
    expr = rec.get("f")
    a_val = rec.get("a")

    try:
        if q_type == 'tangent_line_eq':
            return fig_tangent_line(expr, var, a_val, out_dir, entry_id)

        elif q_type == 'critical_points':
            return fig_critical_points(expr, var, out_dir, entry_id)

    except Exception:
        return None

    return None
