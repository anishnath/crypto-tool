<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - PHP Functions Reference Navigation --%>
        <% String currentFunction=(String) request.getAttribute("currentFunction"); if (currentFunction==null)
            currentFunction="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-logo.svg" alt="PHP"
                            width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">PHP Functions</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Overview --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Overview</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/"
                                        class="nav-link <%= "index".equals(currentFunction) ? "active" : "" %>">
                                        All Functions
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- String Functions --%>
                            <div class="nav-section">
                                <div class="nav-section-title">String Functions</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/strlen.jsp"
                                            class="nav-link <%= "strlen".equals(currentFunction) ? "active" : "" %>">
                                            strlen()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/str_replace.jsp"
                                            class="nav-link <%= "str_replace".equals(currentFunction) ? "active" : "" %>">
                                            str_replace()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/substr.jsp"
                                            class="nav-link <%= "substr".equals(currentFunction) ? "active" : "" %>">
                                            substr()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/strpos.jsp"
                                            class="nav-link <%= "strpos".equals(currentFunction) ? "active" : "" %>">
                                            strpos()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/explode.jsp"
                                            class="nav-link <%= "explode".equals(currentFunction) ? "active" : "" %>">
                                            explode()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/implode.jsp"
                                            class="nav-link <%= "implode".equals(currentFunction) ? "active" : "" %>">
                                            implode()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/trim.jsp"
                                            class="nav-link <%= "trim".equals(currentFunction) ? "active" : "" %>">
                                            trim()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/strtolower.jsp"
                                            class="nav-link <%= "strtolower".equals(currentFunction) ? "active" : "" %>">
                                            strtolower()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/strtoupper.jsp"
                                            class="nav-link <%= "strtoupper".equals(currentFunction) ? "active" : "" %>">
                                            strtoupper()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/sprintf.jsp"
                                            class="nav-link <%= "sprintf".equals(currentFunction) ? "active" : "" %>">
                                            sprintf()
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Multibyte String Functions --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Multibyte String Functions</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_strlen.jsp"
                                                class="nav-link <%= "mb_strlen".equals(currentFunction) ? "active" : "" %>">
                                                mb_strlen()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_substr.jsp"
                                                class="nav-link <%= "mb_substr".equals(currentFunction) ? "active" : "" %>">
                                                mb_substr()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_strtolower.jsp"
                                                class="nav-link <%= "mb_strtolower".equals(currentFunction) ? "active" : "" %>">
                                                mb_strtolower()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_strtoupper.jsp"
                                                class="nav-link <%= "mb_strtoupper".equals(currentFunction) ? "active" : "" %>">
                                                mb_strtoupper()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_strpos.jsp"
                                                class="nav-link <%= "mb_strpos".equals(currentFunction) ? "active" : "" %>">
                                                mb_strpos()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_convert_encoding.jsp"
                                                class="nav-link <%= "mb_convert_encoding".equals(currentFunction) ? "active" : "" %>">
                                                mb_convert_encoding()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_detect_encoding.jsp"
                                                class="nav-link <%= "mb_detect_encoding".equals(currentFunction) ? "active" : "" %>">
                                                mb_detect_encoding()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_str_split.jsp"
                                                class="nav-link <%= "mb_str_split".equals(currentFunction) ? "active" : "" %>">
                                                mb_str_split()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_internal_encoding.jsp"
                                                class="nav-link <%= "mb_internal_encoding".equals(currentFunction) ? "active" : "" %>">
                                                mb_internal_encoding()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/mb_check_encoding.jsp"
                                                class="nav-link <%= "mb_check_encoding".equals(currentFunction) ? "active" : "" %>">
                                                mb_check_encoding()
                                            </a>
                                        </li>

                                    </ul>
                                </div>

                                <%-- Array Functions --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Array Functions</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_map.jsp"
                                                    class="nav-link <%= "array_map".equals(currentFunction) ? "active" : "" %>">
                                                    array_map()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_filter.jsp"
                                                    class="nav-link <%= "array_filter".equals(currentFunction) ? "active" : "" %>">
                                                    array_filter()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_merge.jsp"
                                                    class="nav-link <%= "array_merge".equals(currentFunction) ? "active" : "" %>">
                                                    array_merge()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_push.jsp"
                                                    class="nav-link <%= "array_push".equals(currentFunction) ? "active" : "" %>">
                                                    array_push()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_pop.jsp"
                                                    class="nav-link <%= "array_pop".equals(currentFunction) ? "active" : "" %>">
                                                    array_pop()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_search.jsp"
                                                    class="nav-link <%= "array_search".equals(currentFunction) ? "active" : "" %>">
                                                    array_search()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/in_array.jsp"
                                                    class="nav-link <%= "in_array".equals(currentFunction) ? "active" : "" %>">
                                                    in_array()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_keys.jsp"
                                                    class="nav-link <%= "array_keys".equals(currentFunction) ? "active" : "" %>">
                                                    array_keys()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_values.jsp"
                                                    class="nav-link <%= "array_values".equals(currentFunction) ? "active" : "" %>">
                                                    array_values()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/sort.jsp"
                                                    class="nav-link <%= "sort".equals(currentFunction) ? "active" : "" %>">
                                                    sort()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_splice.jsp"
                                                    class="nav-link <%= "array_splice".equals(currentFunction) ? "active" : "" %>">
                                                    array_splice()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/count.jsp"
                                                    class="nav-link <%= "count".equals(currentFunction) ? "active" : "" %>">
                                                    count()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/krsort.jsp"
                                                    class="nav-link <%= "krsort".equals(currentFunction) ? "active" : "" %>">
                                                    krsort()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/ksort.jsp"
                                                    class="nav-link <%= "ksort".equals(currentFunction) ? "active" : "" %>">
                                                    ksort()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/natcasesort.jsp"
                                                    class="nav-link <%= "natcasesort".equals(currentFunction) ? "active" : "" %>">
                                                    natcasesort()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/natsort.jsp"
                                                    class="nav-link <%= "natsort".equals(currentFunction) ? "active" : "" %>">
                                                    natsort()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/range.jsp"
                                                    class="nav-link <%= "range".equals(currentFunction) ? "active" : "" %>">
                                                    range()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/rsort.jsp"
                                                    class="nav-link <%= "rsort".equals(currentFunction) ? "active" : "" %>">
                                                    rsort()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/shuffle.jsp"
                                                    class="nav-link <%= "shuffle".equals(currentFunction) ? "active" : "" %>">
                                                    shuffle()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_shift.jsp"
                                                    class="nav-link <%= "array_shift".equals(currentFunction) ? "active" : "" %>">
                                                    array_shift()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_unshift.jsp"
                                                    class="nav-link <%= "array_unshift".equals(currentFunction) ? "active" : "" %>">
                                                    array_unshift()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_slice.jsp"
                                                    class="nav-link <%= "array_slice".equals(currentFunction) ? "active" : "" %>">
                                                    array_slice()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_chunk.jsp"
                                                    class="nav-link <%= "array_chunk".equals(currentFunction) ? "active" : "" %>">
                                                    array_chunk()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_unique.jsp"
                                                    class="nav-link <%= "array_unique".equals(currentFunction) ? "active" : "" %>">
                                                    array_unique()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_reverse.jsp"
                                                    class="nav-link <%= "array_reverse".equals(currentFunction) ? "active" : "" %>">
                                                    array_reverse()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_column.jsp"
                                                    class="nav-link <%= "array_column".equals(currentFunction) ? "active" : "" %>">
                                                    array_column()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_combine.jsp"
                                                    class="nav-link <%= "array_combine".equals(currentFunction) ? "active" : "" %>">
                                                    array_combine()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_diff.jsp"
                                                    class="nav-link <%= "array_diff".equals(currentFunction) ? "active" : "" %>">
                                                    array_diff()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/array_intersect.jsp"
                                                    class="nav-link <%= "array_intersect".equals(currentFunction) ? "active" : "" %>">
                                                    array_intersect()
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Math Functions --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Math Functions</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/round.jsp"
                                                        class="nav-link <%= "round".equals(currentFunction) ? "active" : "" %>">
                                                        round()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/floor.jsp"
                                                        class="nav-link <%= "floor".equals(currentFunction) ? "active" : "" %>">
                                                        floor()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/ceil.jsp"
                                                        class="nav-link <%= "ceil".equals(currentFunction) ? "active" : "" %>">
                                                        ceil()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/abs.jsp"
                                                        class="nav-link <%= "abs".equals(currentFunction) ? "active" : "" %>">
                                                        abs()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/rand.jsp"
                                                        class="nav-link <%= "rand".equals(currentFunction) ? "active" : "" %>">
                                                        rand()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/max.jsp"
                                                        class="nav-link <%= "max".equals(currentFunction) ? "active" : "" %>">
                                                        max()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/min.jsp"
                                                        class="nav-link <%= "min".equals(currentFunction) ? "active" : "" %>">
                                                        min()
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Date/Time Functions --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Date/Time Functions</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/checkdate.jsp"
                                                            class="nav-link <%= "checkdate".equals(currentFunction) ? "active" : "" %>">
                                                            checkdate()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/date.jsp"
                                                            class="nav-link <%= "date".equals(currentFunction) ? "active" : "" %>">
                                                            date()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/getdate.jsp"
                                                            class="nav-link <%= "getdate".equals(currentFunction) ? "active" : "" %>">
                                                            getdate()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/gettimeofday.jsp"
                                                            class="nav-link <%= "gettimeofday".equals(currentFunction) ? "active" : "" %>">
                                                            gettimeofday()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/gmdate.jsp"
                                                            class="nav-link <%= "gmdate".equals(currentFunction) ? "active" : "" %>">
                                                            gmdate()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/gmmktime.jsp"
                                                            class="nav-link <%= "gmmktime".equals(currentFunction) ? "active" : "" %>">
                                                            gmmktime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/gmstrftime.jsp"
                                                            class="nav-link <%= "gmstrftime".equals(currentFunction) ? "active" : "" %>">
                                                            gmstrftime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hrtime.jsp"
                                                            class="nav-link <%= "hrtime".equals(currentFunction) ? "active" : "" %>">
                                                            hrtime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/idate.jsp"
                                                            class="nav-link <%= "idate".equals(currentFunction) ? "active" : "" %>">
                                                            idate()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/localtime.jsp"
                                                            class="nav-link <%= "localtime".equals(currentFunction) ? "active" : "" %>">
                                                            localtime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/microtime.jsp"
                                                            class="nav-link <%= "microtime".equals(currentFunction) ? "active" : "" %>">
                                                            microtime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/mktime.jsp"
                                                            class="nav-link <%= "mktime".equals(currentFunction) ? "active" : "" %>">
                                                            mktime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/strftime.jsp"
                                                            class="nav-link <%= "strftime".equals(currentFunction) ? "active" : "" %>">
                                                            strftime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/strptime.jsp"
                                                            class="nav-link <%= "strptime".equals(currentFunction) ? "active" : "" %>">
                                                            strptime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/strtotime.jsp"
                                                            class="nav-link <%= "strtotime".equals(currentFunction) ? "active" : "" %>">
                                                            strtotime()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/time.jsp"
                                                            class="nav-link <%= "time".equals(currentFunction) ? "active" : "" %>">
                                                            time()
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Calendar Functions --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Calendar Functions</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/cal_days_in_month.jsp"
                                                                class="nav-link <%= "cal_days_in_month".equals(currentFunction) ? "active" : "" %>">
                                                                cal_days_in_month()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/cal_from_jd.jsp"
                                                                class="nav-link <%= "cal_from_jd".equals(currentFunction) ? "active" : "" %>">
                                                                cal_from_jd()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/cal_info.jsp"
                                                                class="nav-link <%= "cal_info".equals(currentFunction) ? "active" : "" %>">
                                                                cal_info()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/cal_to_jd.jsp"
                                                                class="nav-link <%= "cal_to_jd".equals(currentFunction) ? "active" : "" %>">
                                                                cal_to_jd()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/easter_date.jsp"
                                                                class="nav-link <%= "easter_date".equals(currentFunction) ? "active" : "" %>">
                                                                easter_date()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/easter_days.jsp"
                                                                class="nav-link <%= "easter_days".equals(currentFunction) ? "active" : "" %>">
                                                                easter_days()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/frenchtojd.jsp"
                                                                class="nav-link <%= "frenchtojd".equals(currentFunction) ? "active" : "" %>">
                                                                frenchtojd()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/gregoriantojd.jsp"
                                                                class="nav-link <%= "gregoriantojd".equals(currentFunction) ? "active" : "" %>">
                                                                gregoriantojd()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jddayofweek.jsp"
                                                                class="nav-link <%= "jddayofweek".equals(currentFunction) ? "active" : "" %>">
                                                                jddayofweek()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jdmonthname.jsp"
                                                                class="nav-link <%= "jdmonthname".equals(currentFunction) ? "active" : "" %>">
                                                                jdmonthname()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jdtofrench.jsp"
                                                                class="nav-link <%= "jdtofrench".equals(currentFunction) ? "active" : "" %>">
                                                                jdtofrench()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jdtogregorian.jsp"
                                                                class="nav-link <%= "jdtogregorian".equals(currentFunction) ? "active" : "" %>">
                                                                jdtogregorian()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jdtojewish.jsp"
                                                                class="nav-link <%= "jdtojewish".equals(currentFunction) ? "active" : "" %>">
                                                                jdtojewish()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jdtojulian.jsp"
                                                                class="nav-link <%= "jdtojulian".equals(currentFunction) ? "active" : "" %>">
                                                                jdtojulian()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jdtounix.jsp"
                                                                class="nav-link <%= "jdtounix".equals(currentFunction) ? "active" : "" %>">
                                                                jdtounix()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/jewishtojd.jsp"
                                                                class="nav-link <%= "jewishtojd".equals(currentFunction) ? "active" : "" %>">
                                                                jewishtojd()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/juliantojd.jsp"
                                                                class="nav-link <%= "juliantojd".equals(currentFunction) ? "active" : "" %>">
                                                                juliantojd()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/unixtojd.jsp"
                                                                class="nav-link <%= "unixtojd".equals(currentFunction) ? "active" : "" %>">
                                                                unixtojd()
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- JSON Functions --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">JSON Functions</div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/json_encode.jsp"
                                                                    class="nav-link <%= "json_encode".equals(currentFunction) ? "active" : "" %>">
                                                                    json_encode()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/json_decode.jsp"
                                                                    class="nav-link <%= "json_decode".equals(currentFunction) ? "active" : "" %>">
                                                                    json_decode()
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <%-- File Functions --%>
                                                        <div class="nav-section">
                                                            <div class="nav-section-title">File Functions</div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/file_get_contents.jsp"
                                                                        class="nav-link <%= "file_get_contents".equals(currentFunction) ? "active" : "" %>">
                                                                        file_get_contents()
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/file_put_contents.jsp"
                                                                        class="nav-link <%= "file_put_contents".equals(currentFunction) ? "active" : "" %>">
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/file_exists.jsp"
                                                                        class="nav-link <%= "file_exists".equals(currentFunction) ? "active" : "" %>">
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <%-- Hash/Crypto Functions --%>
                                                            <div class="nav-section">
                                                                <div class="nav-section-title">Hash/Crypto Functions
                                                                </div>
                                                                <ul class="nav-items">
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hash.jsp"
                                                                            class="nav-link <%= "hash".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hash_algos.jsp"
                                                                            class="nav-link <%= "hash_algos".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hash_equals.jsp"
                                                                            class="nav-link <%= "hash_equals".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hash_hkdf.jsp"
                                                                            class="nav-link <%= "hash_hkdf".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hash_hmac.jsp"
                                                                            class="nav-link <%= "hash_hmac".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hash_hmac_algos.jsp"
                                                                            class="nav-link <%= "hash_hmac_algos".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/hash_pbkdf2.jsp"
                                                                            class="nav-link <%= "hash_pbkdf2".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/random_bytes.jsp"
                                                                            class="nav-link <%= "random_bytes".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/random_int.jsp"
                                                                            class="nav-link <%= "random_int".equals(currentFunction) ? "active" : "" %>">
                                                                        </a>
                                                                    </li>
                                                                </ul>
                                                            </div>

                                                            <%-- Password Hashing Functions --%>
                                                                <div class="nav-section">
                                                                    <div class="nav-section-title">Password Hashing
                                                                    </div>
                                                                    <ul class="nav-items">
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/password_hash.jsp"
                                                                                class="nav-link <%= "password_hash".equals(currentFunction) ? "active" : "" %>">
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/password_verify.jsp"
                                                                                class="nav-link <%= "password_verify".equals(currentFunction) ? "active" : "" %>">
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/password_algos.jsp"
                                                                                class="nav-link <%= "password_algos".equals(currentFunction) ? "active" : "" %>">
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/password_get_info.jsp"
                                                                                class="nav-link <%= "password_get_info".equals(currentFunction) ? "active" : "" %>">
                                                                                password_get_info()
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/password_needs_rehash.jsp"
                                                                                class="nav-link <%= "password_needs_rehash".equals(currentFunction) ? "active" : "" %>">
                                                                                password_needs_rehash()
                                                                            </a>
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <%-- Regular Expressions --%>
                                                                    <div class="nav-section">
                                                                        <div class="nav-section-title">Regular
                                                                            Expressions
                                                                        </div>
                                                                        <ul class="nav-items">
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_match.jsp"
                                                                                    class="nav-link <%= "preg_match".equals(currentFunction) ? "active" : "" %>">
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_match_all.jsp"
                                                                                    class="nav-link <%= "preg_match_all".equals(currentFunction) ? "active" : "" %>">
                                                                                    preg_match_all()
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_replace.jsp"
                                                                                    class="nav-link <%= "preg_replace".equals(currentFunction) ? "active" : "" %>">
                                                                                    preg_replace()
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_replace_callback.jsp"
                                                                                    class="nav-link <%= "preg_replace_callback".equals(currentFunction) ? "active" : "" %>">
                                                                                    preg_replace_callback()
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_split.jsp"
                                                                                    class="nav-link <%= "preg_split".equals(currentFunction) ? "active" : "" %>">
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_grep.jsp"
                                                                                    class="nav-link <%= "preg_grep".equals(currentFunction) ? "active" : "" %>">
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_filter.jsp"
                                                                                    class="nav-link <%= "preg_filter".equals(currentFunction) ? "active" : "" %>">
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/preg_quote.jsp"
                                                                                    class="nav-link <%= "preg_quote".equals(currentFunction) ? "active" : "" %>">
                                                                                </a>
                                                                            </li>
                                                                        </ul>
                                                                    </div>

                                                                    <%-- URL Functions --%>
                                                                        <div class="nav-section">
                                                                            <div class="nav-section-title">URL Functions
                                                                            </div>
                                                                            <ul class="nav-items">
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/urlencode.jsp"
                                                                                        class="nav-link <%= "urlencode".equals(currentFunction) ? "active" : "" %>">
                                                                                        urlencode()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/urldecode.jsp"
                                                                                        class="nav-link <%= "urldecode".equals(currentFunction) ? "active" : "" %>">
                                                                                        urldecode()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/rawurlencode.jsp"
                                                                                        class="nav-link <%= "rawurlencode".equals(currentFunction) ? "active" : "" %>">
                                                                                        rawurlencode()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/rawurldecode.jsp"
                                                                                        class="nav-link <%= "rawurldecode".equals(currentFunction) ? "active" : "" %>">
                                                                                        rawurldecode()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/base64_encode.jsp"
                                                                                        class="nav-link <%= "base64_encode".equals(currentFunction) ? "active" : "" %>">
                                                                                        base64_encode()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/base64_decode.jsp"
                                                                                        class="nav-link <%= "base64_decode".equals(currentFunction) ? "active" : "" %>">
                                                                                        base64_decode()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/parse_url.jsp"
                                                                                        class="nav-link <%= "parse_url".equals(currentFunction) ? "active" : "" %>">
                                                                                        parse_url()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/http_build_query.jsp"
                                                                                        class="nav-link <%= "http_build_query".equals(currentFunction) ? "active" : "" %>">
                                                                                        http_build_query()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/get_meta_tags.jsp"
                                                                                        class="nav-link <%= "get_meta_tags".equals(currentFunction) ? "active" : "" %>">
                                                                                        get_meta_tags()
                                                                                    </a>
                                                                                </li>
                                                                            </ul>
                                                                        </div>

                                                                        <%-- Network Functions --%>
                                                                            <div class="nav-section">
                                                                                <div class="nav-section-title">Network
                                                                                    Functions
                                                                                </div>
                                                                                <ul class="nav-items">
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/gethostbyaddr.jsp"
                                                                                            class="nav-link <%= "gethostbyaddr".equals(currentFunction) ? "active" : "" %>">
                                                                                            gethostbyaddr()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/gethostbyname.jsp"
                                                                                            class="nav-link <%= "gethostbyname".equals(currentFunction) ? "active" : "" %>">
                                                                                            gethostbyname()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/gethostbynamel.jsp"
                                                                                            class="nav-link <%= "gethostbynamel".equals(currentFunction) ? "active" : "" %>">
                                                                                            gethostbynamel()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/getmxrr.jsp"
                                                                                            class="nav-link <%= "getmxrr".equals(currentFunction) ? "active" : "" %>">
                                                                                            getmxrr()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/getservbyname.jsp"
                                                                                            class="nav-link <%= "getservbyname".equals(currentFunction) ? "active" : "" %>">
                                                                                            getservbyname()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/getservbyport.jsp"
                                                                                            class="nav-link <%= "getservbyport".equals(currentFunction) ? "active" : "" %>">
                                                                                            getservbyport()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/ip2long.jsp"
                                                                                            class="nav-link <%= "ip2long".equals(currentFunction) ? "active" : "" %>">
                                                                                            ip2long()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/php-functions/long2ip.jsp"
                                                                                            class="nav-link <%= "long2ip".equals(currentFunction) ? "active" : "" %>">
                                                                                            long2ip()
                                                                                        </a>
                                                                                    </li>
                                                                                </ul>
                                                                            </div>

                                                                            <%-- Variable Functions --%>
                                                                                <div class="nav-section">
                                                                                    <div class="nav-section-title">
                                                                                        Variable
                                                                                        Functions</div>
                                                                                    <ul class="nav-items">
                                                                                        <li class="nav-item">
                                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/isset.jsp"
                                                                                                class="nav-link <%= "isset".equals(currentFunction) ? "active" : "" %>">
                                                                                                isset()
                                                                                            </a>
                                                                                        </li>
                                                                                        <li class="nav-item">
                                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/empty.jsp"
                                                                                                class="nav-link <%= "empty".equals(currentFunction) ? "active" : "" %>">
                                                                                                empty()
                                                                                            </a>
                                                                                        </li>
                                                                                        <li class="nav-item">
                                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/var_dump.jsp"
                                                                                                class="nav-link <%= "var_dump".equals(currentFunction) ? "active" : "" %>">
                                                                                                var_dump()
                                                                                            </a>
                                                                                        </li>
                                                                                        <li class="nav-item">
                                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/print_r.jsp"
                                                                                                class="nav-link <%= "print_r".equals(currentFunction) ? "active" : "" %>">
                                                                                                print_r()
                                                                                            </a>
                                                                                        </li>
                                                                                        <li class="nav-item">
                                                                                            <a href="<%=request.getContextPath()%>/tutorials/php-functions/gettype.jsp"
                                                                                                class="nav-link <%= "gettype".equals(currentFunction) ? "active" : "" %>">
                                                                                                gettype()
                                                                                            </a>
                                                                                        </li>
                                                                                    </ul>
                                                                                </div>

                                                                                <%-- General Functions --%>
                                                                                    <div class="nav-section">
                                                                                        <div class="nav-section-title">
                                                                                            General Functions</div>
                                                                                        <ul class="nav-items">
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/hex2bin.jsp"
                                                                                                    class="nav-link <%= "hex2bin".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n hex2bin()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/pack.jsp"
                                                                                                    class="nav-link <%= "pack".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n pack()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/serialize.jsp"
                                                                                                    class="nav-link <%= "serialize".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n serialize()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/token_name.jsp"
                                                                                                    class="nav-link <%= "token_name".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n token_name()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/uniqid.jsp"
                                                                                                    class="nav-link <%= "uniqid".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n uniqid()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/unpack.jsp"
                                                                                                    class="nav-link <%= "unpack".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n unpack()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/unserialize.jsp"
                                                                                                    class="nav-link <%= "unserialize".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n unserialize()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/zlib_decode.jsp"
                                                                                                    class="nav-link <%= "zlib_decode".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n zlib_decode()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php-functions/zlib_encode.jsp"
                                                                                                    class="nav-link <%= "zlib_encode".equals(currentFunction) ? "active" : "" %>">
                                                                                                    %>">\n zlib_encode()
                                                                                                </a>
                                                                                            </li>
                                                                                        </ul>
                                                                                    </div>

                                                                                    <%-- Back to PHP Tutorial --%>
                                                                                        <div class="nav-section"
                                                                                            style="margin-top: var(--space-6); padding-top: var(--space-4); border-top: 1px solid var(--border);">
                                                                                            <ul class="nav-items">
                                                                                                <li class="nav-item">
                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/php/"
                                                                                                        class="nav-link">
                                                                                                        <svg width="16"
                                                                                                            height="16"
                                                                                                            viewBox="0 0 24 24"
                                                                                                            fill="none"
                                                                                                            stroke="currentColor"
                                                                                                            stroke-width="2"
                                                                                                            style="margin-right: 8px;">
                                                                                                            <path
                                                                                                                d="M19 12H5M12 19l-7-7 7-7" />
                                                                                                        </svg>
                                                                                                        Back to PHP
                                                                                                        Tutorial
                                                                                                    </a>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                </nav>
            </aside>