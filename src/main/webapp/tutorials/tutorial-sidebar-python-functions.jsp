<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - Python Functions Reference Navigation --%>
        <% String currentFunction=(String) request.getAttribute("currentFunction"); if (currentFunction==null)
            currentFunction="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/python-logo.svg" alt="Python"
                            width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">Python Functions</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Overview --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Overview</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/"
                                        class="nav-link <%= " index".equals(currentFunction) ? "active" : "" %>">
                                        All Functions
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Built-in Functions --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Built-in Functions</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/print.jsp"
                                            class="nav-link <%= " print".equals(currentFunction) ? "active" : "" %>">
                                            print()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/len.jsp"
                                            class="nav-link <%= " len".equals(currentFunction) ? "active" : "" %>">
                                            len()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/type.jsp"
                                            class="nav-link <%= " type".equals(currentFunction) ? "active" : "" %>">
                                            type()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/isinstance.jsp"
                                            class="nav-link <%= " isinstance".equals(currentFunction) ? "active" : ""
                                            %>">
                                            isinstance()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/range.jsp"
                                            class="nav-link <%= " range".equals(currentFunction) ? "active" : "" %>">
                                            range()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/enumerate.jsp"
                                            class="nav-link <%= " enumerate".equals(currentFunction) ? "active" : ""
                                            %>">
                                            enumerate()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/zip.jsp"
                                            class="nav-link <%= " zip".equals(currentFunction) ? "active" : "" %>">
                                            zip()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/map.jsp"
                                            class="nav-link <%= " map".equals(currentFunction) ? "active" : "" %>">
                                            map()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/filter.jsp"
                                            class="nav-link <%= " filter".equals(currentFunction) ? "active" : "" %>">
                                            filter()
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/sorted.jsp"
                                            class="nav-link <%= " sorted".equals(currentFunction) ? "active" : "" %>">
                                            sorted()
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Type Conversion --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Type Conversion</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/int.jsp"
                                                class="nav-link <%= " int".equals(currentFunction) ? "active" : "" %>">
                                                int()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/float.jsp"
                                                class="nav-link <%= " float".equals(currentFunction) ? "active" : ""
                                                %>">
                                                float()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/str.jsp"
                                                class="nav-link <%= " str".equals(currentFunction) ? "active" : "" %>">
                                                str()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/bool.jsp"
                                                class="nav-link <%= " bool".equals(currentFunction) ? "active" : "" %>">
                                                bool()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/list.jsp"
                                                class="nav-link <%= " list".equals(currentFunction) ? "active" : "" %>">
                                                list()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/tuple.jsp"
                                                class="nav-link <%= " tuple".equals(currentFunction) ? "active" : ""
                                                %>">
                                                tuple()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict.jsp"
                                                class="nav-link <%= " dict".equals(currentFunction) ? "active" : "" %>">
                                                dict()
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/set.jsp"
                                                class="nav-link <%= " set".equals(currentFunction) ? "active" : "" %>">
                                                set()
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- String Methods --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">String Methods</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_split.jsp"
                                                    class="nav-link <%= " str_split".equals(currentFunction) ? "active"
                                                    : "" %>">
                                                    str.split()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_join.jsp"
                                                    class="nav-link <%= " str_join".equals(currentFunction) ? "active"
                                                    : "" %>">
                                                    str.join()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_strip.jsp"
                                                    class="nav-link <%= " str_strip".equals(currentFunction) ? "active"
                                                    : "" %>">
                                                    str.strip()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_replace.jsp"
                                                    class="nav-link <%= " str_replace".equals(currentFunction)
                                                    ? "active" : "" %>">
                                                    str.replace()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_find.jsp"
                                                    class="nav-link <%= " str_find".equals(currentFunction) ? "active"
                                                    : "" %>">
                                                    str.find()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_upper.jsp"
                                                    class="nav-link <%= " str_upper".equals(currentFunction) ? "active"
                                                    : "" %>">
                                                    str.upper()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_lower.jsp"
                                                    class="nav-link <%= " str_lower".equals(currentFunction) ? "active"
                                                    : "" %>">
                                                    str.lower()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_format.jsp"
                                                    class="nav-link <%= " str_format".equals(currentFunction) ? "active"
                                                    : "" %>">
                                                    str.format()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_startswith.jsp"
                                                    class="nav-link <%= " str_startswith".equals(currentFunction)
                                                    ? "active" : "" %>">
                                                    str.startswith()
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/str_endswith.jsp"
                                                    class="nav-link <%= " str_endswith".equals(currentFunction)
                                                    ? "active" : "" %>">
                                                    str.endswith()
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Math Functions --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Math Functions</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/abs.jsp"
                                                        class="nav-link <%= " abs".equals(currentFunction) ? "active"
                                                        : "" %>">
                                                        abs()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/round.jsp"
                                                        class="nav-link <%= " round".equals(currentFunction) ? "active"
                                                        : "" %>">
                                                        round()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/min.jsp"
                                                        class="nav-link <%= " min".equals(currentFunction) ? "active"
                                                        : "" %>">
                                                        min()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/max.jsp"
                                                        class="nav-link <%= " max".equals(currentFunction) ? "active"
                                                        : "" %>">
                                                        max()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/sum.jsp"
                                                        class="nav-link <%= " sum".equals(currentFunction) ? "active"
                                                        : "" %>">
                                                        sum()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/pow.jsp"
                                                        class="nav-link <%= " pow".equals(currentFunction) ? "active"
                                                        : "" %>">
                                                        pow()
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/divmod.jsp"
                                                        class="nav-link <%= " divmod".equals(currentFunction) ? "active"
                                                        : "" %>">
                                                        divmod()
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- List Methods --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">List Methods</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_append.jsp"
                                                            class="nav-link <%= " list_append".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.append()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_extend.jsp"
                                                            class="nav-link <%= " list_extend".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.extend()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_insert.jsp"
                                                            class="nav-link <%= " list_insert".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.insert()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_remove.jsp"
                                                            class="nav-link <%= " list_remove".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.remove()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_pop.jsp"
                                                            class="nav-link <%= " list_pop".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.pop()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_index.jsp"
                                                            class="nav-link <%= " list_index".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.index()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_count.jsp"
                                                            class="nav-link <%= " list_count".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.count()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_sort.jsp"
                                                            class="nav-link <%= " list_sort".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.sort()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_reverse.jsp"
                                                            class="nav-link <%= " list_reverse".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.reverse()
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/list_copy.jsp"
                                                            class="nav-link <%= " list_copy".equals(currentFunction)
                                                            ? "active" : "" %>">
                                                            list.copy()
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Dictionary Methods --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Dictionary Methods</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_keys.jsp"
                                                                class="nav-link <%= " dict_keys".equals(currentFunction)
                                                                ? "active" : "" %>">
                                                                dict.keys()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_values.jsp"
                                                                class="nav-link <%= "dict_values".equals(currentFunction) ? "active" : "" %>">
                                                                dict.values()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_items.jsp"
                                                                class="nav-link <%= "dict_items".equals(currentFunction) ? "active" : "" %>">
                                                                dict.items()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_get.jsp"
                                                                class="nav-link <%= " dict_get".equals(currentFunction)
                                                                ? "active" : "" %>">
                                                                dict.get()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_update.jsp"
                                                                class="nav-link <%= "dict_update".equals(currentFunction) ? "active" : "" %>">
                                                                dict.update()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_pop.jsp"
                                                                class="nav-link <%= " dict_pop".equals(currentFunction)
                                                                ? "active" : "" %>">
                                                                dict.pop()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_clear.jsp"
                                                                class="nav-link <%= "dict_clear".equals(currentFunction) ? "active" : "" %>">
                                                                dict.clear()
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/dict_setdefault.jsp"
                                                                class="nav-link <%= "dict_setdefault".equals(currentFunction) ? "active" : "" %>">
                                                                dict.setdefault()
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- Set Methods --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">Set Methods</div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_add.jsp"
                                                                    class="nav-link <%= "set_add".equals(currentFunction) ? "active" : "" %>">
                                                                    set.add()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_remove.jsp"
                                                                    class="nav-link <%= "set_remove".equals(currentFunction) ? "active" : "" %>">
                                                                    set.remove()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_union.jsp"
                                                                    class="nav-link <%= "set_union".equals(currentFunction) ? "active" : "" %>">
                                                                    set.union()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_intersection.jsp"
                                                                    class="nav-link <%= "set_intersection".equals(currentFunction) ? "active" : "" %>">
                                                                    set.intersection()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_difference.jsp"
                                                                    class="nav-link <%= "set_difference".equals(currentFunction) ? "active" : "" %>">
                                                                    set.difference()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_discard.jsp"
                                                                    class="nav-link <%= "set_discard".equals(currentFunction) ? "active" : "" %>">
                                                                    set.discard()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_pop.jsp"
                                                                    class="nav-link <%= "set_pop".equals(currentFunction) ? "active" : "" %>">
                                                                    set.pop()
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/set_clear.jsp"
                                                                    class="nav-link <%= "set_clear".equals(currentFunction) ? "active" : "" %>">
                                                                    set.clear()
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <%-- Tuple Methods --%>
                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Tuple Methods</div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/tuple_count.jsp"
                                                                        class="nav-link <%= "tuple_count".equals(currentFunction) ? "active" : "" %>">
                                                                        tuple.count()
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/tuple_index.jsp"
                                                                        class="nav-link <%= "tuple_index".equals(currentFunction) ? "active" : "" %>">
                                                                        tuple.index()
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <%-- File Methods --%>
                                                            <div class="nav-section">
                                                                <div class="nav-section-title">File Methods</div>
                                                                <ul class="nav-items">
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/python_open.jsp"
                                                                            class="nav-link <%= "python_open".equals(currentFunction) ? "active" : "" %>">
                                                                            open()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_read.jsp"
                                                                            class="nav-link <%= "file_read".equals(currentFunction) ? "active" : "" %>">
                                                                            file.read()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_readline.jsp"
                                                                            class="nav-link <%= "file_readline".equals(currentFunction) ? "active" : "" %>">
                                                                            file.readline()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_readlines.jsp"
                                                                            class="nav-link <%= "file_readlines".equals(currentFunction) ? "active" : "" %>">
                                                                            file.readlines()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_write.jsp"
                                                                            class="nav-link <%= "file_write".equals(currentFunction) ? "active" : "" %>">
                                                                            file.write()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_writelines.jsp"
                                                                            class="nav-link <%= "file_writelines".equals(currentFunction) ? "active" : "" %>">
                                                                            file.writelines()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_close.jsp"
                                                                            class="nav-link <%= "file_close".equals(currentFunction) ? "active" : "" %>">
                                                                            file.close()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_seek.jsp"
                                                                            class="nav-link <%= "file_seek".equals(currentFunction) ? "active" : "" %>">
                                                                            file.seek()
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/file_tell.jsp"
                                                                            class="nav-link <%= "file_tell".equals(currentFunction) ? "active" : "" %>">
                                                                            file.tell()
                                                                        </a>
                                                                    </li>
                                                                </ul>
                                                            </div>

                                                            <%-- Date & Time --%>
                                                                <div class="nav-section">
                                                                    <div class="nav-section-title">Date & Time</div>
                                                                    <ul class="nav-items">
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/datetime_now.jsp"
                                                                                class="nav-link <%= "datetime_now".equals(currentFunction) ? "active" : "" %>">
                                                                                datetime.now()
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/datetime_date.jsp"
                                                                                class="nav-link <%= "datetime_date".equals(currentFunction) ? "active" : "" %>">
                                                                                datetime.date()
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/datetime_strftime.jsp"
                                                                                class="nav-link <%= "datetime_strftime".equals(currentFunction) ? "active" : "" %>">
                                                                                strftime()
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/datetime_strptime.jsp"
                                                                                class="nav-link <%= "datetime_strptime".equals(currentFunction) ? "active" : "" %>">
                                                                                strptime()
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/time_time.jsp"
                                                                                class="nav-link <%= "time_time".equals(currentFunction) ? "active" : "" %>">
                                                                                time.time()
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/time_sleep.jsp"
                                                                                class="nav-link <%= "time_sleep".equals(currentFunction) ? "active" : "" %>">
                                                                                time.sleep()
                                                                            </a>
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <%-- JSON --%>
                                                                    <div class="nav-section">
                                                                        <div class="nav-section-title">JSON</div>
                                                                        <ul class="nav-items">
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/json_loads.jsp"
                                                                                    class="nav-link <%= "json_loads".equals(currentFunction) ? "active" : "" %>">
                                                                                    json.loads()
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/json_dumps.jsp"
                                                                                    class="nav-link <%= "json_dumps".equals(currentFunction) ? "active" : "" %>">
                                                                                    json.dumps()
                                                                                </a>
                                                                            </li>
                                                                        </ul>
                                                                    </div>

                                                                    <%-- Hashing --%>
                                                                        <div class="nav-section">
                                                                            <div class="nav-section-title">Hashing</div>
                                                                            <ul class="nav-items">
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/hashlib_md5.jsp"
                                                                                        class="nav-link <%= "hashlib_md5".equals(currentFunction) ? "active" : "" %>">
                                                                                        hashlib.md5()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/hashlib_sha256.jsp"
                                                                                        class="nav-link <%= "hashlib_sha256".equals(currentFunction) ? "active" : "" %>">
                                                                                        hashlib.sha256()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/hashlib_sha1.jsp"
                                                                                        class="nav-link <%= "hashlib_sha1".equals(currentFunction) ? "active" : "" %>">
                                                                                        hashlib.sha1()
                                                                                    </a>
                                                                                </li>
                                                                                <li class="nav-item">
                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/hashlib_sha512.jsp"
                                                                                        class="nav-link <%= "hashlib_sha512".equals(currentFunction) ? "active" : "" %>">
                                                                                        hashlib.sha512()
                                                                                    </a>
                                                                                </li>
                                                                            </ul>
                                                                        </div>

                                                                        <%-- Secrets --%>
                                                                            <div class="nav-section">
                                                                                <div class="nav-section-title">Secrets
                                                                                </div>
                                                                                <ul class="nav-items">
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/secrets_token_hex.jsp"
                                                                                            class="nav-link <%= "secrets_token_hex".equals(currentFunction) ? "active" : "" %>">
                                                                                            secrets.token_hex()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/secrets_token_urlsafe.jsp"
                                                                                            class="nav-link <%= "secrets_token_urlsafe".equals(currentFunction) ? "active" : "" %>">
                                                                                            secrets.token_urlsafe()
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="nav-item">
                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/secrets_token_bytes.jsp"
                                                                                            class="nav-link <%= "secrets_token_bytes".equals(currentFunction) ? "active" : "" %>">
                                                                                            secrets.token_bytes()
                                                                                        </a>
                                                                                    </li>
                                                                                </ul>
                                                                            </div>

                                                                            <%-- Encoding --%>
                                                                                <div class="nav-section">
                                                                                    <div class="nav-section-title">
                                                                                        Encoding
                                                                                    </div>
                                                                                    <ul class="nav-items">
                                                                                        <li class="nav-item">
                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/base64_b64encode.jsp"
                                                                                                class="nav-link <%= "base64_b64encode".equals(currentFunction) ? "active" : "" %>">
                                                                                                base64.b64encode()
                                                                                            </a>
                                                                                        </li>
                                                                                        <li class="nav-item">
                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/base64_b64decode.jsp"
                                                                                                class="nav-link <%= "base64_b64decode".equals(currentFunction) ? "active" : "" %>">
                                                                                                base64.b64decode()
                                                                                            </a>
                                                                                        </li>
                                                                                    </ul>
                                                                                </div>

                                                                                <%-- Regular Expressions --%>
                                                                                    <div class="nav-section">
                                                                                        <div class="nav-section-title">
                                                                                            Regular Expressions</div>
                                                                                        <ul class="nav-items">
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/re_match.jsp"
                                                                                                    class="nav-link <%= "re_match".equals(currentFunction) ? "active" : "" %>">
                                                                                                    re.match()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/re_search.jsp"
                                                                                                    class="nav-link <%= "re_search".equals(currentFunction) ? "active" : "" %>">
                                                                                                    re.search()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/re_findall.jsp"
                                                                                                    class="nav-link <%= "re_findall".equals(currentFunction) ? "active" : "" %>">
                                                                                                    re.findall()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/re_sub.jsp"
                                                                                                    class="nav-link <%= "re_sub".equals(currentFunction) ? "active" : "" %>">
                                                                                                    re.sub()
                                                                                                </a>
                                                                                            </li>
                                                                                            <li class="nav-item">
                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/re_split.jsp"
                                                                                                    class="nav-link <%= "re_split".equals(currentFunction) ? "active" : "" %>">
                                                                                                    re.split()
                                                                                                </a>
                                                                                            </li>
                                                                                        </ul>
                                                                                    </div>

                                                                                    <%-- Random --%>
                                                                                        <div class="nav-section">
                                                                                            <div
                                                                                                class="nav-section-title">
                                                                                                Random</div>
                                                                                            <ul class="nav-items">
                                                                                                <li class="nav-item">
                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/random_random.jsp"
                                                                                                        class="nav-link <%= "random_random".equals(currentFunction) ? "active" : "" %>">
                                                                                                        random.random()
                                                                                                    </a>
                                                                                                </li>
                                                                                                <li class="nav-item">
                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/random_randint.jsp"
                                                                                                        class="nav-link <%= "random_randint".equals(currentFunction) ? "active" : "" %>">
                                                                                                        random.randint()
                                                                                                    </a>
                                                                                                </li>
                                                                                                <li class="nav-item">
                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/random_choice.jsp"
                                                                                                        class="nav-link <%= "random_choice".equals(currentFunction) ? "active" : "" %>">
                                                                                                        random.choice()
                                                                                                    </a>
                                                                                                </li>
                                                                                                <li class="nav-item">
                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/random_shuffle.jsp"
                                                                                                        class="nav-link <%= "random_shuffle".equals(currentFunction) ? "active" : "" %>">
                                                                                                        random.shuffle()
                                                                                                    </a>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>

                                                                                        <%-- Math --%>
                                                                                            <div class="nav-section">
                                                                                                <div
                                                                                                    class="nav-section-title">
                                                                                                    Math</div>
                                                                                                <ul class="nav-items">
                                                                                                    <li
                                                                                                        class="nav-item">
                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/math_sqrt.jsp"
                                                                                                            class="nav-link <%= "math_sqrt".equals(currentFunction) ? "active" : "" %>">
                                                                                                            math.sqrt()
                                                                                                        </a>
                                                                                                    </li>
                                                                                                    <li
                                                                                                        class="nav-item">
                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/math_ceil.jsp"
                                                                                                            class="nav-link <%= "math_ceil".equals(currentFunction) ? "active" : "" %>">
                                                                                                            math.ceil()
                                                                                                        </a>
                                                                                                    </li>
                                                                                                    <li
                                                                                                        class="nav-item">
                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/math_floor.jsp"
                                                                                                            class="nav-link <%= "math_floor".equals(currentFunction) ? "active" : "" %>">
                                                                                                            math.floor()
                                                                                                        </a>
                                                                                                    </li>
                                                                                                    <li
                                                                                                        class="nav-item">
                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/math_factorial.jsp"
                                                                                                            class="nav-link <%= "math_factorial".equals(currentFunction) ? "active" : "" %>">
                                                                                                            math.factorial()
                                                                                                        </a>
                                                                                                    </li>
                                                                                                    <li
                                                                                                        class="nav-item">
                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/math_pi.jsp"
                                                                                                            class="nav-link <%= "math_pi".equals(currentFunction) ? "active" : "" %>">
                                                                                                            math.pi
                                                                                                        </a>
                                                                                                    </li>
                                                                                                </ul>
                                                                                            </div>

                                                                                            <%-- OS & System --%>
                                                                                                <div
                                                                                                    class="nav-section">
                                                                                                    <div
                                                                                                        class="nav-section-title">
                                                                                                        OS & System
                                                                                                    </div>
                                                                                                    <ul
                                                                                                        class="nav-items">
                                                                                                        <li class="nav-item">
                                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/os_path_exists.jsp"
                                                                                                                class="nav-link <%= "os_path_exists".equals(currentFunction) ? "active" : "" %>">
                                                                                                                os.path.exists()
                                                                                                            </a>
                                                                                                        </li>
                                                                                                        <li class="nav-item">
                                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/os_getcwd.jsp"
                                                                                                                class="nav-link <%= "os_getcwd".equals(currentFunction) ? "active" : "" %>">
                                                                                                                os.getcwd()
                                                                                                            </a>
                                                                                                        </li>
                                                                                                        <li class="nav-item">
                                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/os_listdir.jsp"
                                                                                                                class="nav-link <%= "os_listdir".equals(currentFunction) ? "active" : "" %>">
                                                                                                                os.listdir()
                                                                                                            </a>
                                                                                                        </li>
                                                                                                        <li class="nav-item">
                                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/os_mkdir.jsp"
                                                                                                                class="nav-link <%= "os_mkdir".equals(currentFunction) ? "active" : "" %>">
                                                                                                                os.mkdir()
                                                                                                            </a>
                                                                                                        </li>
                                                                                                        <li class="nav-item">
                                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/os_remove.jsp"
                                                                                                                class="nav-link <%= "os_remove".equals(currentFunction) ? "active" : "" %>">
                                                                                                                os.remove()
                                                                                                            </a>
                                                                                                        </li>
                                                                                                    </ul>
                                                                                                </div>

                                                                                                <%-- Networking --%>
                                                                                                    <div class="nav-section">
                                                                                                        <div class="nav-section-title">Networking</div>
                                                                                                        <ul class="nav-items">
                                                                                                            <li class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/urllib_parse_urlencode.jsp"
                                                                                                                    class="nav-link <%= "urllib_parse_urlencode".equals(currentFunction) ? "active" : "" %>">
                                                                                                                    urllib.parse.urlencode()
                                                                                                                </a>
                                                                                                            </li>
                                                                                                            <li class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/urllib_parse_urlparse.jsp"
                                                                                                                    class="nav-link <%= "urllib_parse_urlparse".equals(currentFunction) ? "active" : "" %>">
                                                                                                                    urllib.parse.urlparse()
                                                                                                                </a>
                                                                                                            </li>
                                                                                                            <li class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/urllib_parse_quote.jsp"
                                                                                                                    class="nav-link <%= "urllib_parse_quote".equals(currentFunction) ? "active" : "" %>">
                                                                                                                    urllib.parse.quote()
                                                                                                                </a>
                                                                                                            </li>
                                                                                                            <li class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/urllib_parse_unquote.jsp"
                                                                                                                    class="nav-link <%= "urllib_parse_unquote".equals(currentFunction) ? "active" : "" %>">
                                                                                                                    urllib.parse.unquote()
                                                                                                                </a>
                                                                                                            </li>
                                                                                                            <li class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/urllib_request_urlopen.jsp"
                                                                                                                    class="nav-link <%= "urllib_request_urlopen".equals(currentFunction) ? "active" : "" %>">
                                                                                                                    urllib.request.urlopen()
                                                                                                                </a>
                                                                                                            </li>
                                                                                                            <li class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/socket_gethostname.jsp"
                                                                                                                    class="nav-link <%= "socket_gethostname".equals(currentFunction) ? "active" : "" %>">
                                                                                                                    socket.gethostname()
                                                                                                                </a>
                                                                                                            </li>
                                                                                                            <li class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python-functions/socket_gethostbyname.jsp"
                                                                                                                    class="nav-link <%= "socket_gethostbyname".equals(currentFunction) ? "active" : "" %>">
                                                                                                                    socket.gethostbyname()
                                                                                                                </a>
                                                                                                            </li>
                                                                                                        </ul>
                                                                                                    </div>

                                                                                                    <%-- Collections --%>
                                                                                                        <div class="nav-section">
                                                                                                            <div class="nav-section-title">Collections</div>
                                                                                                            <ul class="nav-items">
                                                                                                                <li class="nav-item">
                                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/collections_counter.jsp"
                                                                                                                        class="nav-link <%= "collections_counter".equals(currentFunction) ? "active" : "" %>">
                                                                                                                        collections.Counter()
                                                                                                                    </a>
                                                                                                                </li>
                                                                                                                <li class="nav-item">
                                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/collections_defaultdict.jsp"
                                                                                                                        class="nav-link <%= "collections_defaultdict".equals(currentFunction) ? "active" : "" %>">
                                                                                                                        collections.defaultdict()
                                                                                                                    </a>
                                                                                                                </li>
                                                                                                                <li class="nav-item">
                                                                                                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/collections_deque.jsp"
                                                                                                                        class="nav-link <%= "collections_deque".equals(currentFunction) ? "active" : "" %>">
                                                                                                                        collections.deque()
                                                                                                                    </a>
                                                                                                                </li>
                                                                                                            </ul>
                                                                                                        </div>

                                                                                                        <%-- Itertools --%>
                                                                                                            <div class="nav-section">
                                                                                                                <div class="nav-section-title">Itertools</div>
                                                                                                                <ul class="nav-items">
                                                                                                                    <li class="nav-item">
                                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/itertools_chain.jsp"
                                                                                                                            class="nav-link <%= "itertools_chain".equals(currentFunction) ? "active" : "" %>">
                                                                                                                            itertools.chain()
                                                                                                                        </a>
                                                                                                                    </li>
                                                                                                                    <li class="nav-item">
                                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/itertools_combinations.jsp"
                                                                                                                            class="nav-link <%= "itertools_combinations".equals(currentFunction) ? "active" : "" %>">
                                                                                                                            itertools.combinations()
                                                                                                                        </a>
                                                                                                                    </li>
                                                                                                                    <li class="nav-item">
                                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/itertools_permutations.jsp"
                                                                                                                            class="nav-link <%= "itertools_permutations".equals(currentFunction) ? "active" : "" %>">
                                                                                                                            itertools.permutations()
                                                                                                                        </a>
                                                                                                                    </li>
                                                                                                                    <li class="nav-item">
                                                                                                                        <a href="<%=request.getContextPath()%>/tutorials/python-functions/itertools_groupby.jsp"
                                                                                                                            class="nav-link <%= "itertools_groupby".equals(currentFunction) ? "active" : "" %>">
                                                                                                                            itertools.groupby()
                                                                                                                        </a>
                                                                                                                    </li>
                                                                                                                </ul>
                                                                                                            </div>

                                                                                                            <%-- Input/Output --%>
                                                                                                                <div class="nav-section">
                                                                                                                    <div class="nav-section-title">Input/Output</div>
                                                                                                                    <ul class="nav-items">
                                                                                                                        <li class="nav-item">
                                                                                                                            <a href="<%=request.getContextPath()%>/tutorials/python-functions/input_function.jsp"
                                                                                                                                class="nav-link <%= "input_function".equals(currentFunction) ? "active" : "" %>">
                                                                                                                                input()
                                                                                                                            </a>
                                                                                                                        </li>
                                                                                                                    </ul>
                                                                                                                </div>

                                                                                                                <%-- Back
                                                                                                                    to
                                                                                                                    Python
                                                                                                                    Tutorial
                                                                                                                    --%>
                                                                                                                    <div class="nav-section"
                                                                                                                        style="margin-top: var(--space-6); padding-top: var(--space-4); border-top: 1px solid var(--border);">
                                                                                                                        <ul
                                                                                                                            class="nav-items">
                                                                                                                            <li
                                                                                                                                class="nav-item">
                                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/python/"
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
                                                                                                                                    Back
                                                                                                                                    to
                                                                                                                                    Python
                                                                                                                                    Tutorial
                                                                                                                                </a>
                                                                                                                            </li>
                                                                                                                        </ul>
                                                                                                                    </div>
                </nav>
            </aside>