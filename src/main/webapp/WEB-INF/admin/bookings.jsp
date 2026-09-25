<%@ page contentType="text/html;charset=UTF-8" import="java.util.*" %>
<%!
    String e(Object v) {
        return v == null ? "" : v.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
    }
    String l(Object v) {
        return v == null ? "" : v.toString().replace("_"," ");
    }
    int n(Map<String,Integer> m, String k) {
        return m.get(k) == null ? 0 : m.get(k);
    }
%>
<%
    List<Map<String,Object>> rows = (List<Map<String,Object>>) request.getAttribute("bookings");
    Map<String,Object> x = (Map<String,Object>) request.getAttribute("selected");
    Map<String,Integer> counts = (Map<String,Integer>) request.getAttribute("counts");
    String c = request.getContextPath();
    String csrf = (String) session.getAttribute("bookingAdminCsrf");
    String status = (String) request.getAttribute("filterStatus");
    String search = (String) request.getAttribute("search");
    boolean archived = Boolean.TRUE.equals(request.getAttribute("showArchived"));
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Booking Desk | TravelTourism Admin</title>
    <link rel="stylesheet" href="<%=c%>/css/admin-workspace.css?v=6">
    <link rel="stylesheet" href="<%=c%>/css/admin-enquiries.css?v=6">
    <link rel="stylesheet" href="<%=c%>/css/admin-bookings.css?v=6">
</head>
<body class="holiday-admin enquiry-admin booking-admin">
    <% request.setAttribute("adminSection", "bookings"); %>
    <%@ include file="/WEB-INF/admin/navigation.jspf" %>

    <section class="admin-intro enquiry-intro">
        <div>
            <span class="eyebrow">RESERVATION WORKFLOW</span>
            <h1>Booking desk</h1>
            <p>Review guest requests, confirm availability and keep every next action recorded.</p>
        </div>
        <div class="admin-metrics">
            <div>
                <strong><%= n(counts, "pending") %></strong>
                <span>pending</span>
            </div>
            <div>
                <strong><%= n(counts, "reviewing") %></strong>
                <span>reviewing</span>
            </div>
            <div>
                <strong><%= n(counts, "confirmed") %></strong>
                <span>confirmed</span>
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
                <input name="q" value="<%= e(search) %>" placeholder="Search guest, package or reference">
                <input type="hidden" name="status" value="<%= e(status) %>">
                <% if (archived) { %>
                    <input type="hidden" name="archived" value="true">
                <% } %>
                <button type="submit">Search</button>
            </form>

            <nav class="enquiry-filters" aria-label="Booking status filters">
                <a class="<%= "all".equals(status) && !archived ? "active" : "" %>" href="<%=c%>/admin/bookings">
                    All
                </a>
                <a class="<%= "pending".equals(status) ? "active" : "" %>" href="<%=c%>/admin/bookings?status=pending">
                    Pending <span><%= n(counts, "pending") %></span>
                </a>
                <a class="<%= "reviewing".equals(status) ? "active" : "" %>" href="<%=c%>/admin/bookings?status=reviewing">
                    Reviewing
                </a>
                <a class="<%= archived ? "active" : "" %>" href="<%=c%>/admin/bookings?archived=true">
                    Archived
                </a>
            </nav>

            <div class="enquiry-list">
                <% if (rows == null || rows.isEmpty()) { %>
                    <div class="enquiry-none">
                        <span>◇</span>
                        <h3>No booking requests</h3>
                        <p>New package requests will appear here.</p>
                    </div>
                <% } else {
                    for (Map<String,Object> r : rows) { %>
                        <a class="enquiry-list-item <%= x != null && r.get("reference").equals(x.get("reference")) ? "selected" : "" %>"
                           href="<%=c%>/admin/bookings?reference=<%= e(r.get("reference")) %><%= archived ? "&archived=true" : "" %>">
                            <div>
                                <span class="status-dot booking-status-<%= e(r.get("status")) %>"></span>
                                <strong><%= e(r.get("customer_name")) %></strong>
                                <time><%= e(r.get("created_at")) %></time>
                            </div>
                            <p><%= e(r.get("package_name")) %></p>
                            <small><%= e(r.get("reference")) %></small>
                        </a>
                <%  }
                } %>
            </div>
        </aside>

        <!-- RIGHT DETAIL PANEL -->
        <section class="enquiry-detail">
            <% if (x == null) { %>
                <div class="enquiry-empty-detail">
                    <span>TT</span>
                    <h2>Select a booking request</h2>
                    <p>Choose a request from the list to review its package, traveller details, and record your next action.</p>
                </div>
            <% } else { %>
                <header class="enquiry-detail-head">
                    <div>
                        <p class="eyebrow">REFERENCE</p>
                        <h2><%= e(x.get("customer_name")) %></h2>
                        <code><%= e(x.get("reference")) %></code>
                    </div>
                    <span class="enquiry-status booking-status-<%= e(x.get("status")) %>">
                        <%= e(l(x.get("status"))) %>
                    </span>
                </header>

                <div class="booking-package-card">
                    <div>
                        <p class="eyebrow"><%= e(l(x.get("package_type"))) %> PACKAGE</p>
                        <h3><%= e(x.get("package_name")) %></h3>
                        <p>From <%= e(x.get("departure_city")) %> · <%= e(x.get("duration")) %> days · <%= e(x.get("travel_date")) %></p>
                    </div>
                    <strong>₹<%= e(x.get("total_price")) %><small>estimated total</small></strong>
                </div>

                <div class="enquiry-contact-strip">
                    <a href="mailto:<%= e(x.get("email")) %>">
                        <span>Email Address</span>
                        <strong><%= e(x.get("email")) %></strong>
                    </a>
                    <a href="tel:<%= e(x.get("phone")) %>">
                        <span>Phone Number</span>
                        <strong><%= e(x.get("phone")) %></strong>
                    </a>
                </div>

                <div class="enquiry-detail-grid">
                    <div>
                        <span>Travellers</span>
                        <strong><%= e(x.get("travelers")) %> guests</strong>
                    </div>
                    <div>
                        <span>Price per person</span>
                        <strong>₹<%= e(x.get("price_per_person")) %></strong>
                    </div>
                    <div>
                        <span>Contact preference</span>
                        <strong><%= e(x.get("contact_preference")) %></strong>
                    </div>
                    <div>
                        <span>Pickup location</span>
                        <strong><%= e(x.get("pickup_location")) %></strong>
                    </div>
                    <div>
                        <span>Booking channel</span>
                        <strong><%= e(x.get("booking_channel")) %></strong>
                    </div>
                    <div>
                        <span>Terms accepted</span>
                        <strong><%= e(x.get("terms_accepted_at")) %></strong>
                    </div>
                </div>

                <article class="enquiry-message">
                    <p class="eyebrow">TRAVEL PREFERENCES &amp; NOTES</p>
                    <p><%= e(x.get("preferences")) %></p>
                </article>

                <form class="enquiry-action-form" method="post" action="<%=c%>/admin/bookings">
                    <input type="hidden" name="csrf" value="<%= e(csrf) %>">
                    <input type="hidden" name="reference" value="<%= e(x.get("reference")) %>">
                    <input type="hidden" name="currentArchived" value="<%= archived %>">

                    <div class="section-heading">
                        <span>✓</span>
                        <div>
                            <h3>Manage this request</h3>
                            <p>Record availability checks, guest communication and the next action.</p>
                        </div>
                    </div>

                    <div class="enquiry-action-fields">
                        <label>
                            Booking status
                            <select name="status">
                                <% for (String z : new String[]{"pending", "reviewing", "confirmed", "completed", "cancelled"}) { %>
                                    <option value="<%= z %>" <%= z.equals(x.get("status")) ? "selected" : "" %>>
                                        <%= e(l(z)) %>
                                    </option>
                                <% } %>
                            </select>
                        </label>

                        <label>
                            Follow-up date
                            <input type="date" name="followUpDate" value="<%= e(x.get("follow_up_date")) %>">
                        </label>

                        <label class="full">
                            Private admin notes
                            <textarea name="adminNotes" rows="5" maxlength="3000" placeholder="Record private details, agreements, special requests or conversation notes..."><%= e(x.get("admin_notes")) %></textarea>
                        </label>
                    </div>

                    <div class="enquiry-actions">
                        <button class="button primary" type="submit">Save workflow</button>
                        <button class="button" type="submit" name="archiveAction" value="<%= archived ? "restore" : "archive" %>">
                            <%= archived ? "Restore request" : "Archive request" %>
                        </button>
                    </div>
                </form>

                <% if (archived) { %>
                    <details class="enquiry-delete">
                        <summary>Permanent deletion</summary>
                        <p>This permanently deletes the booking snapshot and guest details. This action cannot be undone.</p>
                        <form method="post" action="<%=c%>/admin/bookings" onsubmit="return confirm('Permanently delete this archived booking request?')">
                            <input type="hidden" name="csrf" value="<%= e(csrf) %>">
                            <input type="hidden" name="reference" value="<%= e(x.get("reference")) %>">
                            <input type="hidden" name="action" value="delete">
                            <button class="button" type="submit">Delete permanently</button>
                        </form>
                    </details>
                <% } %>
            <% } %>
        </section>
    </main>
</body>
</html>