<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,java.net.URLEncoder,java.nio.charset.StandardCharsets" %>
<%!
    String e(Object v) {
        if (v == null) return "";
        return v.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
    }
    String label(Object v) {
        if (v == null) return "";
        return v.toString().replace("_"," ");
    }
    int n(Map<String,Integer> m, String k) {
        return m.get(k) == null ? 0 : m.get(k);
    }
%>
<%
    List<Map<String,Object>> rows = (List<Map<String,Object>>) request.getAttribute("enquiries");
    Map<String,Object> selected = (Map<String,Object>) request.getAttribute("selected");
    Map<String,Integer> counts = (Map<String,Integer>) request.getAttribute("counts");
    String context = request.getContextPath();
    String csrf = (String) session.getAttribute("enquiryCsrf");
    String status = (String) request.getAttribute("filterStatus");
    String search = (String) request.getAttribute("search");
    boolean archived = Boolean.TRUE.equals(request.getAttribute("showArchived"));
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Enquiries | TravelTourism Admin</title>
    <link rel="stylesheet" href="<%= context %>/css/admin-workspace.css?v=6">
    <link rel="stylesheet" href="<%= context %>/css/admin-enquiries.css?v=6">
</head>
<body class="holiday-admin enquiry-admin">
    <% request.setAttribute("adminSection", "enquiries"); %>
    <%@ include file="/WEB-INF/admin/navigation.jspf" %>

    <section class="admin-intro enquiry-intro">
        <div>
            <span class="eyebrow">GUEST RELATIONSHIPS</span>
            <h1>Enquiry desk</h1>
            <p>Review each request, record the next action and keep follow-ups organized.</p>
        </div>
        <div class="admin-metrics">
            <div>
                <strong><%= n(counts, "new") %></strong>
                <span>new</span>
            </div>
            <div>
                <strong><%= n(counts, "in_progress") %></strong>
                <span>in progress</span>
            </div>
            <div>
                <strong><%= n(counts, "responded") %></strong>
                <span>responded</span>
            </div>
        </div>
    </section>

    <main class="enquiry-layout">
        <% if (request.getAttribute("notice") != null) { %>
            <div class="admin-notice enquiry-wide">
                <%= e(request.getAttribute("notice")) %>
            </div>
        <% } %>
        <% if (request.getAttribute("loadError") != null) { %>
            <div class="admin-error enquiry-wide">
                <%= e(request.getAttribute("loadError")) %>
            </div>
        <% } %>

        <!-- LEFT LIST PANEL -->
        <aside class="enquiry-list-panel">
            <form class="enquiry-search" method="get">
                <input name="q" value="<%= e(search) %>" placeholder="Search name, email or destination">
                <input type="hidden" name="status" value="<%= e(status) %>">
                <% if (archived) { %>
                    <input type="hidden" name="archived" value="true">
                <% } %>
                <button type="submit">Search</button>
            </form>

            <nav class="enquiry-filters" aria-label="Enquiry status filters">
                <a class="<%= "all".equals(status) ? "active" : "" %>" href="<%= context %>/admin/enquiries">
                    All
                </a>
                <a class="<%= "new".equals(status) ? "active" : "" %>" href="<%= context %>/admin/enquiries?status=new">
                    New <span><%= n(counts, "new") %></span>
                </a>
                <a class="<%= "in_progress".equals(status) ? "active" : "" %>" href="<%= context %>/admin/enquiries?status=in_progress">
                    In progress
                </a>
                <a class="<%= archived ? "active" : "" %>" href="<%= context %>/admin/enquiries?archived=true">
                    Archived
                </a>
            </nav>

            <div class="enquiry-list">
                <% if (rows == null || rows.isEmpty()) { %>
                    <div class="enquiry-none">
                        <span>◇</span>
                        <h3>No enquiries here</h3>
                        <p>New guest messages will appear in this workspace.</p>
                    </div>
                <% } else {
                    for (Map<String,Object> row : rows) { %>
                        <a class="enquiry-list-item <%= selected != null && row.get("id").equals(selected.get("id")) ? "selected" : "" %>"
                           href="<%= context %>/admin/enquiries?id=<%= row.get("id") %><%= archived ? "&archived=true" : "" %>">
                            <div>
                                <span class="status-dot status-<%= e(row.get("status")) %>"></span>
                                <strong><%= e(row.get("name")) %></strong>
                                <time><%= e(row.get("created_at")) %></time>
                            </div>
                            <p><%= e(row.get("preferred_destination") == null || row.get("preferred_destination").toString().isBlank() ? label(row.get("enquiry_type")) : row.get("preferred_destination")) %></p>
                            <small><%= e(row.get("message")) %></small>
                        </a>
                <%  }
                } %>
            </div>
        </aside>

        <!-- RIGHT DETAIL PANEL -->
        <section class="enquiry-detail">
            <% if (selected == null) { %>
                <div class="enquiry-empty-detail">
                    <span>TT</span>
                    <h2>Select an enquiry</h2>
                    <p>Choose a guest request from the list to review their travel preferences and record your next action.</p>
                </div>
            <% } else { %>
                <header class="enquiry-detail-head">
                    <div>
                        <p class="eyebrow">ENQUIRY #<%= selected.get("id") %></p>
                        <h2><%= e(selected.get("name")) %></h2>
                        <span class="enquiry-status status-<%= e(selected.get("status")) %>">
                            <%= e(label(selected.get("status"))) %>
                        </span>
                    </div>
                    <time>Received <%= e(selected.get("created_at")) %></time>
                </header>

                <div class="enquiry-contact-strip">
                    <a href="mailto:<%= e(selected.get("email")) %>">
                        <span>Email Address</span>
                        <strong><%= e(selected.get("email")) %></strong>
                    </a>
                    <a href="tel:<%= e(selected.get("phone")) %>">
                        <span>Phone Number</span>
                        <strong><%= e(selected.get("phone")) %></strong>
                    </a>
                </div>

                <div class="enquiry-detail-grid">
                    <div>
                        <span>Enquiry type</span>
                        <strong><%= e(label(selected.get("enquiry_type"))) %></strong>
                    </div>
                    <div>
                        <span>Destination</span>
                        <strong><%= e(selected.get("preferred_destination")) %></strong>
                    </div>
                    <div>
                        <span>Travel month</span>
                        <strong><%= e(selected.get("travel_month")) %></strong>
                    </div>
                    <div>
                        <span>Travellers</span>
                        <strong><%= e(selected.get("travellers")) %></strong>
                    </div>
                    <div>
                        <span>Budget range</span>
                        <strong><%= e(selected.get("budget_range")) %></strong>
                    </div>
                    <div>
                        <span>Originating tour ID</span>
                        <strong><%= e(selected.get("tour_id")) %></strong>
                    </div>
                </div>

                <article class="enquiry-message">
                    <p class="eyebrow">GUEST MESSAGE</p>
                    <p><%= e(selected.get("message")) %></p>
                </article>

                <form class="enquiry-action-form" method="post" action="<%= context %>/admin/enquiries">
                    <input type="hidden" name="csrf" value="<%= e(csrf) %>">
                    <input type="hidden" name="id" value="<%= selected.get("id") %>">
                    <input type="hidden" name="currentArchived" value="<%= archived %>">

                    <div class="section-heading">
                        <span>✓</span>
                        <div>
                            <h3>Plan the next action</h3>
                            <p>These notes are private and visible only to team members in this admin workspace.</p>
                        </div>
                    </div>

                    <div class="enquiry-action-fields">
                        <label>
                            Workflow status
                            <select name="status">
                                <% for (String s : new String[]{"new", "in_progress", "responded", "closed"}) { %>
                                    <option value="<%= s %>" <%= s.equals(selected.get("status")) ? "selected" : "" %>>
                                        <%= e(label(s)) %>
                                    </option>
                                <% } %>
                            </select>
                        </label>

                        <label>
                            Follow-up date
                            <input type="date" name="followUpDate" value="<%= e(selected.get("follow_up_date")) %>">
                        </label>

                        <label class="full">
                            Internal notes
                            <textarea name="adminNotes" rows="5" maxlength="3000" placeholder="Record what was discussed, what was promised, or what should happen next..."><%= e(selected.get("admin_notes")) %></textarea>
                        </label>
                    </div>

                    <div class="enquiry-actions">
                        <button class="button primary" type="submit">Save workflow</button>
                        <button class="button" type="submit" name="archiveAction" value="<%= archived ? "restore" : "archive" %>">
                            <%= archived ? "Restore enquiry" : "Archive enquiry" %>
                        </button>
                    </div>
                </form>

                <% if (archived) { %>
                    <details class="enquiry-delete">
                        <summary>Permanent deletion</summary>
                        <p>This permanently removes the guest contact details, message and internal notes. It cannot be undone.</p>
                        <form method="post" action="<%= context %>/admin/enquiries" onsubmit="return confirm('Permanently delete this archived enquiry?')">
                            <input type="hidden" name="csrf" value="<%= e(csrf) %>">
                            <input type="hidden" name="id" value="<%= selected.get("id") %>">
                            <input type="hidden" name="action" value="delete">
                            <button class="button" type="submit">Delete enquiry permanently</button>
                        </form>
                    </details>
                <% } %>
            <% } %>
        </section>
    </main>
</body>
</html>