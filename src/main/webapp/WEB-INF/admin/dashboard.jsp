<%@ page contentType="text/html;charset=UTF-8" import="java.util.Map" %>
<%
    Map<String,Integer> s = (Map<String,Integer>) request.getAttribute("stats");
    String c = request.getContextPath();
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Overview | TravelTourism</title>
    <link rel="stylesheet" href="<%=c%>/css/admin-workspace.css?v=6">
    <link rel="stylesheet" href="<%=c%>/css/admin-dashboard.css?v=6">
</head>
<body class="holiday-admin admin-dashboard">
    <% request.setAttribute("adminSection", "overview"); %>
    <%@ include file="/WEB-INF/admin/navigation.jspf" %>

    <main>
        <!-- HERO BANNER -->
        <section class="dashboard-hero">
            <div>
                <p class="eyebrow">TRAVELTOUSIM ADMIN PANEL</p>
                <h1>Your website,<br><em>at a glance.</em></h1>
                <p>Manage the journeys guests discover, the stories they see, and every enquiry they send from one clear starting point.</p>
            </div>
        </section>

        <!-- SUMMARY METRICS -->
        <section class="dashboard-summary" aria-label="Key Performance Indicators">
            <div>
                <span>Published tours</span>
                <strong><%= s.get("activeTours") %></strong>
                <small><%= s.get("tours") %> total destinations</small>
            </div>
            <div>
                <span>Live occasion holidays</span>
                <strong><%= s.get("activeHolidays") %></strong>
                <small><%= s.get("holidays") %> total packages</small>
            </div>
            <div>
                <span>Open bookings</span>
                <strong><%= s.get("openBookings") %></strong>
                <small><%= s.get("pendingBookings") %> waiting for review</small>
            </div>
            <div>
                <span>Open enquiries</span>
                <strong><%= s.get("openEnquiries") %></strong>
                <small><%= s.get("newEnquiries") %> waiting for review</small>
            </div>
        </section>

        <!-- WORKSPACE MODULES HEADING -->
        <section class="dashboard-heading">
            <div>
                <p class="eyebrow">MANAGEMENT AREAS</p>
                <h2>What would you like to work on?</h2>
            </div>
            <p>Each workspace keeps its own content, photography, and visitor-facing controls together.</p>
        </section>

        <!-- MODULE CARDS -->
        <section class="dashboard-modules">
            <!-- 01: Homepage Studio -->
            <a href="<%=c%>/admin/homepage" class="dashboard-module dashboard-module-home">
                <span class="module-number">01</span>
                <div class="module-mark" aria-hidden="true">H</div>
                <p class="eyebrow">FIRST IMPRESSION</p>
                <h3>Homepage studio</h3>
                <p>Edit hero wording, destination introductions, occasion messaging and all homepage photography.</p>
                <span class="module-link">Manage homepage <b>→</b></span>
            </a>

            <!-- 02: Destinations -->
            <a href="<%=c%>/admin/tours" class="dashboard-module">
                <span class="module-number">02</span>
                <div class="module-mark" aria-hidden="true">D</div>
                <p class="eyebrow">TOUR COLLECTION</p>
                <h3>Destinations</h3>
                <p>Create and refine tours, details, itineraries, hotels, visibility and galleries.</p>
                <span class="module-link">Manage destinations <b>→</b></span>
            </a>

            <!-- 03: Customized Holidays -->
            <a href="<%=c%>/admin/holidays" class="dashboard-module">
                <span class="module-number">03</span>
                <div class="module-mark" aria-hidden="true">C</div>
                <p class="eyebrow">OCCASION PACKAGES</p>
                <h3>Customized holidays</h3>
                <p>Shape birthday, honeymoon, anniversary, family and group packages with cover photos and galleries.</p>
                <span class="module-link">Manage holidays <b>→</b></span>
            </a>

            <!-- 04: Booking Desk -->
            <a href="<%=c%>/admin/bookings" class="dashboard-module dashboard-module-enquiries">
                <span class="module-number">04</span>
                <div class="module-mark" aria-hidden="true">B</div>
                <p class="eyebrow">RESERVATION WORKFLOW</p>
                <h3>Booking desk</h3>
                <p>Review booking requests, contact travellers, schedule follow-ups, add private notes and manage each request through completion.</p>
                <span class="module-link">Open bookings <b>→</b></span>
                <% if (s.get("pendingBookings") > 0) { %>
                    <strong class="module-alert"><%= s.get("pendingBookings") %> new</strong>
                <% } %>
            </a>

            <!-- 05: Enquiry Desk -->
            <a href="<%=c%>/admin/enquiries" class="dashboard-module dashboard-module-enquiries">
                <span class="module-number">05</span>
                <div class="module-mark" aria-hidden="true">E</div>
                <p class="eyebrow">GUEST RELATIONSHIPS</p>
                <h3>Enquiry desk</h3>
                <p>Review guest requests, record follow-ups, update workflow status and manage archives.</p>
                <span class="module-link">Open enquiries <b>→</b></span>
                <% if (s.get("newEnquiries") > 0) { %>
                    <strong class="module-alert"><%= s.get("newEnquiries") %> new</strong>
                <% } %>
            </a>
        </section>

    </main>
</body>
</html>