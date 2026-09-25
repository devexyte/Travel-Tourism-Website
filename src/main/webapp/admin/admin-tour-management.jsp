<%!
private String esc(Object value) {
    return value == null ? "" : value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
}
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String message = (String) request.getAttribute("adminMessage");

    if (message == null) {
        message = request.getParameter("message");
    }

    java.util.List<java.util.Map<String, Object>> tours =
            (java.util.List<java.util.Map<String, Object>>)
                    request.getAttribute("tours");

    java.util.Map<String, Object> selectedTour =
            (java.util.Map<String, Object>)
                    request.getAttribute("selectedTour");

    Integer selectedTourId = null;

    if (selectedTour != null && selectedTour.get("id") != null) {
        selectedTourId =
                ((Number) selectedTour.get("id")).intValue();
    }

    /*
     * selectedTour == null means CREATE mode.
     * selectedTour != null means EDIT mode.
     */
    boolean createMode = selectedTour == null;
    long publishedCount = tours == null ? 0 : tours.stream().filter(t -> "active".equalsIgnoreCase(String.valueOf(t.get("status")))).count();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Tour Management</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%= esc( request.getContextPath() ) %>/css/admin-tour-management.css?v=6"><link rel="stylesheet" href="<%= esc( request.getContextPath() ) %>/css/admin-workspace.css?v=6">

<script defer src="<%= esc(request.getContextPath()) %>/js/admin-destinations.js"></script></head>


<body class="tour-admin"><% request.setAttribute("adminSection", "tours"); %><%@ include file="/WEB-INF/admin/navigation.jspf" %>


<!-- =========================================================
     HEADER
========================================================= -->

<div class="admin-intro destination-admin-intro"><div><span class="eyebrow">YOUR DESTINATION COLLECTION</span><h1>Good journeys start here.</h1><p>Shape the stays, stories and experiences your travellers can discover.</p></div>
<div class="admin-metrics"><div><strong><%= tours == null ? 0 : tours.size() %></strong><span>Destinations</span></div><div><strong><%= publishedCount %></strong><span>Published</span></div><div><strong><%= (tours == null ? 0 : tours.size()) - publishedCount %></strong><span>Hidden</span></div></div></div>


<div class="container">


    <!-- =====================================================
         MESSAGE
    ====================================================== -->

    <% if (message != null && !message.trim().isEmpty()) { %>

        <div class="message">

            <%= esc( message ) %>

        </div>

    <% } %>


    <!-- =====================================================
         MAIN DASHBOARD
    ====================================================== -->

    <div class="dashboard">


        <!-- =================================================
             LEFT SIDE
        ================================================== -->

        <aside class="sidebar">


            <!-- SIDEBAR HEADER -->

            <div class="sidebar-header">

                <div class="sidebar-title-row">

                    <h2 class="sidebar-title">
                        Tour Packages
                    </h2>

                    <span class="tour-count">
                        <%= esc( tours != null ? tours.size() : 0 ) %>
                    </span>

                </div>


                <p class="sidebar-subtitle">
                    Select a package to edit its
                    information and content.
                </p>


                <!-- NEW TOUR BUTTON -->

                <a
                    href="<%= esc( request.getContextPath() ) %>/admin/tours"
                    class="add-tour-btn <%= esc( createMode ? "active" : "" ) %>"
                >

                    <span class="plus-icon">+</span>

                    Create New Tour

                </a>


                <!-- TOUR SEARCH -->

                <div class="tour-search">

                    <span class="search-icon"></span>

                    <input
                        type="search"
                        id="tourSearch"
                        placeholder="Search tour packages..."
                        autocomplete="off"
                        aria-label="Search tour packages"
                    >

                    <button
                        type="button"
                        id="clearTourSearch"
                        class="clear-search"
                        aria-label="Clear search"
                    >
                        ×
                    </button>

                </div>

                <div
                    id="searchResultCount"
                    class="search-result-count"
                ></div>

            </div>


            <!-- =================================================
                 EXISTING TOUR LIST
            =================================================== -->

            <div class="tour-list" id="tourList">

                <%
                    if (tours != null && !tours.isEmpty()) {

                        for (
                            java.util.Map<String,Object> tour
                            : tours
                        ) {

                            Integer id = null;

                            if (tour.get("id") != null) {

                                id =
                                    ((Number)
                                        tour.get("id"))
                                        .intValue();
                            }

                            boolean active =
                                selectedTourId != null &&
                                selectedTourId.equals(id);

                            String status =
                                String.valueOf(
                                    tour.get("status")
                                );

                            boolean isActive =
                                "active".equalsIgnoreCase(status);
                %>


                    <!-- INDIVIDUAL TOUR -->

                    <a
                        href="<%= esc( request.getContextPath() ) %>/admin/tours?tourId=<%= esc( id ) %>"
                        class="tour-item <%= esc( active ? "active" : "" ) %>"
                        data-tour-search="<%= esc( String.valueOf(tour.get("name")) ) %> <%= esc( String.valueOf(tour.get("category")) ) %> <%= esc( String.valueOf(tour.get("departure_city")) ) %> <%= esc( String.valueOf(tour.get("duration")) ) %> <%= esc( String.valueOf(tour.get("price")) ) %> <%= esc( status ) %>"
                    >

                        <div class="tour-name">

                            <%= esc( tour.get("name") ) %>

                        </div>


                        <div class="tour-meta">

                            <strong>
                                <%= esc( tour.get("category") ) %>
                            </strong>

                            <br>

                            <%= esc( tour.get("duration") ) %> days
                            · ₹<%= esc( tour.get("price") ) %>

                            <br>

                            <%= esc( tour.get("departure_city") ) %>

                        </div>


                        <span
                            class="status-badge <%= esc( isActive
                                ? "status-active"
                                : "status-inactive" ) %>"
                        >

                            <%= isActive ? "Published" : "Hidden" %>
                        </span>

                    </a>


                <%
                        }

                    } else {
                %>


                    <!-- NO TOURS -->

                    <div class="empty">

                        <div class="empty-icon">
                            +
                        </div>

                        No tour packages created yet.

                    </div>


                <%
                    }
                %>


                <!-- SEARCH EMPTY STATE -->

                <div
                    id="searchEmpty"
                    class="search-empty"
                >

                    <div class="search-empty-icon">
                        ⌕
                    </div>

                    No matching tour packages found.

                </div>

            </div>

        </aside>



        <!-- =================================================
             RIGHT SIDE WORKSPACE
        =================================================== -->

        <main class="workspace">


            <!-- =================================================
                 WORKSPACE HEADER
            =================================================== -->

            <div class="workspace-header">

                <div class="workspace-title">

                    <% if (createMode) { %>

                        <small>
                            Tour Management
                        </small>

                        <h2>
                            Create a New Tour Package
                        </h2>

                        <p>
                            Add a new package to your tour collection.
                        </p>

                    <% } else { %>

                        <small>
                            Editing Tour Package
                        </small>

                        <h2>
                            <%= esc( selectedTour.get("name") ) %>
                        </h2>

                        <p>
                            Manage all information related to this package.
                        </p>

                    <% } %>

                </div>


                <% if (!createMode && "active".equals(String.valueOf(selectedTour.get("status")))) { %><a class="button" href="<%= esc(request.getContextPath()) %>/tour-details?id=<%= esc(selectedTour.get("id")) %>" target="_blank" rel="noopener">View details ↗</a><% } %><div class="workspace-badge">

                    <%= esc( createMode
                            ? "NEW PACKAGE"
                            : "PACKAGE #" + selectedTour.get("id") ) %>

                </div>

            </div>



            <!-- =================================================
                 CREATE NEW TOUR
            ================================================= -->

            <% if (createMode) { %>


                <div class="card">

                    <div class="card-header">

                        <div>

                            <h2>
                                Create New Tour
                            </h2>

                            <p>
                                Enter the basic information for the
                                new tour package.
                            </p>

                        </div>

                    </div>


                    <div class="create-intro">

                        <strong>
                            New tour package
                        </strong>

                        After creating the tour, it will immediately
                        become available in the left-side package list.
                        Select it from there to manage its complete
                        details, itinerary, hotels and images.

                    </div>


                    <form
                        method="post"
                        action="<%= esc( request.getContextPath() ) %>/admin/tours"
                    ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                        <input
                            type="hidden"
                            name="action"
                            value="createTour"
                        >


                        <label>
                            Tour Name
                        </label>

                        <input
                            type="text"
                            name="name"
                            required
                            maxlength="150"
                            placeholder="Example: Goa Beach Holiday"
                        ><label>Destination card summary</label><textarea name="short_description" maxlength="15000" rows="3"></textarea>


                        <div class="row">

                            <div>

                                <label>
                                    Category
                                </label>

                                <input
                                    type="text"
                                    name="category"
                                    required
                                    maxlength="50"
                                    placeholder="Nature"
                                >

                            </div>


                            <div>

                                <label>
                                    Departure City
                                </label>

                                <input
                                    type="text"
                                    name="departure_city"
                                    required
                                    maxlength="50"
                                    placeholder="Mumbai"
                                >

                            </div>

                        </div>


                        <div class="row">

                            <div>

                                <label>
                                    Duration (Days)
                                </label>

                                <input
                                    type="number"
                                    name="duration"
                                    min="1"
                                    required
                                    placeholder="5"
                                >

                            </div>


                            <div>

                                <label>
                                    Price
                                </label>

                                <input
                                    type="number"
                                    name="price"
                                    min="0"
                                    step="0.01"
                                    required
                                    placeholder="24999"
                                >

                            </div>

                        </div>


                        <label>
                            Visibility
                        </label>

                        <select name="status">

                            <option value="active">
                                Published — available to book
                            </option>

                            <option value="inactive">
                                Hidden — removed from website
                            </option>

                        </select><p class="visibility-help">Published tours appear on Destinations and can be booked. Hidden tours stay in admin and cannot receive new bookings. Save this section to apply.</p>


                        <button
                            type="submit"
                            class="button primary"
                        >
                            Create Tour Package
                        </button>

                    </form>

                </div>


            <% } else { %>


                <!-- =================================================
                     EDIT EXISTING TOUR
                ================================================== -->


                <!-- =================================================
                     BASIC TOUR INFORMATION
                ================================================== -->

                <div class="card">

                    <div class="card-header">

                        <div>

                            <h2>
                                Basic Tour Information
                            </h2>

                            <p>
                                Update the primary information
                                displayed for this package.
                            </p>

                        </div>

                    </div>


                    <form
                        method="post"
                        action="<%= esc( request.getContextPath() ) %>/admin/tours"
                    ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                        <input
                            type="hidden"
                            name="action"
                            value="updateTour"
                        >

                        <input
                            type="hidden"
                            name="tourId"
                            value="<%= esc( selectedTour.get("id") ) %>"
                        >


                        <label>
                            Tour Name
                        </label>

                        <input
                            type="text"
                            name="name"
                            value="<%= esc( selectedTour.get("name") ) %>"
                            required
                            maxlength="150"
                        ><label>Destination card summary</label><textarea name="short_description" maxlength="15000" rows="3"><%= esc( selectedTour == null ? "" : selectedTour.get("short_description") ) %></textarea>


                        <div class="row">

                            <div>

                                <label>
                                    Category
                                </label>

                                <input
                                    type="text"
                                    name="category"
                                    value="<%= esc( selectedTour.get("category") ) %>"
                                    required
                                    maxlength="50"
                                >

                            </div>


                            <div>

                                <label>
                                    Departure City
                                </label>

                                <input
                                    type="text"
                                    name="departure_city"
                                    value="<%= esc( selectedTour.get("departure_city") ) %>"
                                    required
                                    maxlength="50"
                                >

                            </div>

                        </div>


                        <div class="row-3">

                            <div>

                                <label>
                                    Duration
                                </label>

                                <input
                                    type="number"
                                    name="duration"
                                    value="<%= esc( selectedTour.get("duration") ) %>"
                                    min="1"
                                    required
                                >

                            </div>


                            <div>

                                <label>
                                    Price
                                </label>

                                <input
                                    type="number"
                                    name="price"
                                    value="<%= esc( selectedTour.get("price") ) %>"
                                    min="0"
                                    step="0.01"
                                    required
                                >

                            </div>


                            <div>

                                <label>
                                    Visibility
                                </label>

                                <select name="status">

                                    <option
                                        value="active"
                                        <%= esc( "active".equals(
                                            String.valueOf(
                                                selectedTour.get("status")
                                            )
                                        ) ? "selected" : "" ) %>
                                    >
                                        Published — available to book
                                    </option>

                                    <option
                                        value="inactive"
                                        <%= esc( "inactive".equals(
                                            String.valueOf(
                                                selectedTour.get("status")
                                            )
                                        ) ? "selected" : "" ) %>
                                    >
                                        Hidden — removed from website
                                    </option>

                                </select><p class="visibility-help">Published tours appear on Destinations and can be booked. Hidden tours stay in admin and cannot receive new bookings. Save this section to apply.</p>

                            </div>

                        </div>


                        <button
                            type="submit"
                            class="button primary"
                        >
                            Save Tour Changes
                        </button>

                    </form>


                    <!-- DELETE TOUR -->

                    <div class="danger-zone">

                        <strong>
                            Delete this tour
                        </strong>

                        <p class="muted">
                            Deleting the tour will also delete its
                            details, images, itinerary and hotel
                            records because your database uses
                            ON DELETE CASCADE.
                        </p>


                        <form
                            method="post"
                            action="<%= esc( request.getContextPath() ) %>/admin/tours"
                            onsubmit="return confirm('Delete this entire tour and all related data?');"
                        ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                            <input
                                type="hidden"
                                name="action"
                                value="deleteTour"
                            >

                            <input
                                type="hidden"
                                name="tourId"
                                value="<%= esc( selectedTour.get("id") ) %>"
                            >

                            <button
                                type="submit"
                                class="button danger"
                            >
                                Delete Entire Tour
                            </button>

                        </form>

                    </div>

                </div>



                <!-- =================================================
                     TOUR DETAILS
                ================================================== -->

                <%
                    java.util.Map<String,Object> details =
                            (java.util.Map<String,Object>)
                                request.getAttribute("tourDetails");
                %>


                <div class="card">

                    <div class="card-header">

                        <div>

                            <h2>
                                Tour Details
                            </h2>

                            <p>
                                Add the description, route,
                                highlights and other package information.
                            </p>

                        </div>

                    </div>


                    <form
                        method="post"
                        action="<%= esc( request.getContextPath() ) %>/admin/tours"
                    ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                        <input
                            type="hidden"
                            name="action"
                            value="updateDetails"
                        >

                        <input
                            type="hidden"
                            name="tourId"
                            value="<%= esc( selectedTour.get("id") ) %>"
                        >


                        <label>
                            Long Description
                        </label>

                        <textarea name="long_description"><%= esc(
                            details != null &&
                            details.get("long_description") != null
                            ? details.get("long_description")
                            : ""
                        ) %></textarea>


                        <div class="row">

                            <div>

                                <label>
                                    Duration Text
                                </label>

                                <input
                                    type="text"
                                    name="duration_text"
                                    value="<%= esc(
                                        details != null &&
                                        details.get("duration_text") != null
                                        ? details.get("duration_text")
                                        : ""
                                    ) %>"
                                    placeholder="5 Days / 4 Nights"
                                >

                            </div>


                            <div>

                                <label>
                                    Best Time
                                </label>

                                <input
                                    type="text"
                                    name="best_time"
                                    value="<%= esc(
                                        details != null &&
                                        details.get("best_time") != null
                                        ? details.get("best_time")
                                        : ""
                                    ) %>"
                                    placeholder="October to March"
                                >

                            </div>

                        </div>


                        <div class="row">

                            <div>

                                <label>
                                    States Covered
                                </label>

                                <input
                                    type="text"
                                    name="states_covered"
                                    value="<%= esc(
                                        details != null &&
                                        details.get("states_covered") != null
                                        ? details.get("states_covered")
                                        : ""
                                    ) %>"
                                >

                            </div>


                            <div>

                                <label>
                                    Cities Covered
                                </label>

                                <input
                                    type="text"
                                    name="cities_covered"
                                    value="<%= esc(
                                        details != null &&
                                        details.get("cities_covered") != null
                                        ? details.get("cities_covered")
                                        : ""
                                    ) %>"
                                >

                            </div>

                        </div>


                        <label>
                            Route
                        </label>

                        <textarea
                            name="route"
                            class="small-textarea"
                        ><%= esc(
                            details != null &&
                            details.get("route") != null
                            ? details.get("route")
                            : ""
                        ) %></textarea>


                        <label>
                            Highlights
                        </label>

                        <textarea
                            name="highlights"
                            class="small-textarea"
                        ><%= esc(
                            details != null &&
                            details.get("highlights") != null
                            ? details.get("highlights")
                            : ""
                        ) %></textarea>


                        <label>
                            Inclusions
                        </label>

                        <textarea
                            name="inclusions"
                            class="small-textarea"
                        ><%= esc(
                            details != null &&
                            details.get("inclusions") != null
                            ? details.get("inclusions")
                            : ""
                        ) %></textarea>


                        <label>
                            Exclusions
                        </label>

                        <textarea
                            name="exclusions"
                            class="small-textarea"
                        ><%= esc(
                            details != null &&
                            details.get("exclusions") != null
                            ? details.get("exclusions")
                            : ""
                        ) %></textarea>


                        <label>
                            Preparation
                        </label>

                        <textarea
                            name="preparation"
                            class="small-textarea"
                        ><%= esc(
                            details != null &&
                            details.get("preparation") != null
                            ? details.get("preparation")
                            : ""
                        ) %></textarea>


                        <label>
                            Payment Terms
                        </label>

                        <textarea
                            name="payment_terms"
                            class="small-textarea"
                        ><%= esc(
                            details != null &&
                            details.get("payment_terms") != null
                            ? details.get("payment_terms")
                            : ""
                        ) %></textarea>


                        <label>
                            Upgrades Information
                        </label>

                        <textarea
                            name="upgrades_info"
                            class="small-textarea"
                        ><%= esc(
                            details != null &&
                            details.get("upgrades_info") != null
                            ? details.get("upgrades_info")
                            : ""
                        ) %></textarea>


                        <label>
                            Google Maps Embed URL
                        </label>

                        <textarea
                            name="map_embed"
                            class="small-textarea"
                            placeholder="https://www.google.com/maps/embed?..."
                        ><%= esc(
                            details != null &&
                            details.get("map_embed") != null
                            ? details.get("map_embed")
                            : ""
                        ) %></textarea>


                        <button
                            type="submit"
                            class="button success"
                        >
                            Save Tour Details
                        </button>

                    </form>

                </div>



                <!-- =================================================
                     ITINERARY
                ================================================== -->

                <div class="card">

                    <div class="card-header">

                        <div>

                            <h2>
                                Tour Itinerary
                            </h2>

                            <p>
                                Build and manage the day-by-day
                                travel schedule.
                            </p>

                        </div>

                    </div>


                    <form
                        method="post"
                        action="<%= esc( request.getContextPath() ) %>/admin/tours"
                    ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                        <input
                            type="hidden"
                            name="action"
                            value="addItinerary"
                        >

                        <input
                            type="hidden"
                            name="tourId"
                            value="<%= esc( selectedTour.get("id") ) %>"
                        >


                        <div class="row">

                            <div>

                                <label>
                                    Day Number
                                </label>

                                <input
                                    type="number"
                                    name="day_number"
                                    min="1"
                                    required
                                >

                            </div>


                            <div>

                                <label>
                                    Day Title
                                </label>

                                <input
                                    type="text"
                                    name="day_title"
                                    maxlength="150"
                                    required
                                    placeholder="Arrival & City Tour"
                                >

                            </div>

                        </div>


                        <label>
                            Day Description
                        </label>

                        <textarea
                            name="day_description"
                            required
                            placeholder="Describe the activities, sightseeing and experiences for this day..."
                        ></textarea>


                        <button
                            type="submit"
                            class="button primary"
                        >
                            Add Itinerary Day
                        </button>

                    </form>


                    <%
                        java.util.List<java.util.Map<String,Object>> itinerary =
                            (java.util.List<java.util.Map<String,Object>>)
                                request.getAttribute("itinerary");
                    %>


                    <% if (itinerary != null &&
                           !itinerary.isEmpty()) { %>


                        <div class="table-wrapper">

                            <table>

                                <thead>

                                    <tr>

                                        <th>Day</th>
                                        <th>Title</th>
                                        <th>Description</th>
                                        <th>Action</th>

                                    </tr>

                                </thead>


                                <tbody>

                                <% for (
                                    java.util.Map<String,Object> day
                                    : itinerary
                                ) { %>


                                    <tr>

                                        <td colspan="4">

                                            <form
                                                method="post"
                                                action="<%= esc( request.getContextPath() ) %>/admin/tours"
                                                style="margin:0;"
                                            ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                                                <input
                                                    type="hidden"
                                                    name="action"
                                                    value="updateItinerary"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="tourId"
                                                    value="<%= esc( selectedTour.get("id") ) %>"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="id"
                                                    value="<%= esc( day.get("id") ) %>"
                                                >


                                                <div
                                                    style="
                                                        display:grid;
                                                        grid-template-columns:
                                                            90px
                                                            1fr
                                                            2fr
                                                            160px;
                                                        gap:12px;
                                                        align-items:start;
                                                    "
                                                >

                                                    <div>

                                                        <input
                                                            type="number"
                                                            name="day_number"
                                                            value="<%= esc( day.get("day_number") ) %>"
                                                            min="1"
                                                            required
                                                        >

                                                    </div>


                                                    <div>

                                                        <input
                                                            type="text"
                                                            name="day_title"
                                                            value="<%= esc( day.get("day_title") ) %>"
                                                            required
                                                        >

                                                    </div>


                                                    <div>

                                                        <textarea
                                                            name="day_description"
                                                            class="small-textarea"
                                                            required
                                                        ><%= esc( day.get("day_description") ) %></textarea>

                                                    </div>


                                                    <div>

                                                        <button
                                                            type="submit"
                                                            class="button primary"
                                                        >
                                                            Save
                                                        </button>

                                                    </div>

                                                </div>

                                            </form>


                                            <form
                                                method="post"
                                                action="<%= esc( request.getContextPath() ) %>/admin/tours"
                                                onsubmit="return confirm('Delete this itinerary day?');"
                                            ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                                                <input
                                                    type="hidden"
                                                    name="action"
                                                    value="deleteItinerary"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="tourId"
                                                    value="<%= esc( selectedTour.get("id") ) %>"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="id"
                                                    value="<%= esc( day.get("id") ) %>"
                                                >

                                                <button
                                                    type="submit"
                                                    class="button danger"
                                                >
                                                    Delete
                                                </button>

                                            </form>

                                        </td>

                                    </tr>


                                <% } %>

                                </tbody>

                            </table>

                        </div>


                    <% } else { %>


                        <div class="empty">

                            <div class="empty-icon">
                                +
                            </div>

                            No itinerary days added yet.

                        </div>


                    <% } %>

                </div>



                <!-- =================================================
                     HOTELS
                ================================================== -->

                <div class="card">

                    <div class="card-header">

                        <div>

                            <h2>
                                Hotels
                            </h2>

                            <p>
                                Add accommodation information
                                for the tour.
                            </p>

                        </div>

                    </div>


                    <form
                        method="post"
                        action="<%= esc( request.getContextPath() ) %>/admin/tours"
                    ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                        <input
                            type="hidden"
                            name="action"
                            value="addHotel"
                        >

                        <input
                            type="hidden"
                            name="tourId"
                            value="<%= esc( selectedTour.get("id") ) %>"
                        >


                        <div class="row">

                            <div>

                                <label>
                                    City
                                </label>

                                <input
                                    type="text"
                                    name="city"
                                    maxlength="100"
                                    required
                                >

                            </div>


                            <div>

                                <label>
                                    Hotel Name
                                </label>

                                <input
                                    type="text"
                                    name="hotel_name"
                                    maxlength="150"
                                    required
                                >

                            </div>

                        </div>


                        <div class="row">

                            <div>

                                <label>
                                    Check In
                                </label>

                                <input
                                    type="date"
                                    name="check_in"
                                >

                            </div>


                            <div>

                                <label>
                                    Check Out
                                </label>

                                <input
                                    type="date"
                                    name="check_out"
                                >

                            </div>

                        </div>


                        <button
                            type="submit"
                            class="button primary"
                        >
                            Add Hotel
                        </button>

                    </form>


                    <%
                        java.util.List<java.util.Map<String,Object>> hotels =
                            (java.util.List<java.util.Map<String,Object>>)
                                request.getAttribute("hotels");
                    %>


                    <% if (hotels != null &&
                           !hotels.isEmpty()) { %>


                        <div class="table-wrapper">

                            <table>

                                <thead>

                                    <tr>

                                        <th>City</th>
                                        <th>Hotel</th>
                                        <th>Check In</th>
                                        <th>Check Out</th>
                                        <th>Action</th>

                                    </tr>

                                </thead>


                                <tbody>

                                <% for (
                                    java.util.Map<String,Object> hotel
                                    : hotels
                                ) { %>


                                    <tr>

                                        <td>
                                            <%= esc( hotel.get("city") ) %>
                                        </td>


                                        <td>

                                            <strong>
                                                <%= esc( hotel.get("hotel_name") ) %>
                                            </strong>

                                        </td>


                                        <td>

                                            <%= esc( hotel.get("check_in") != null
                                                ? hotel.get("check_in")
                                                : "-" ) %>

                                        </td>


                                        <td>

                                            <%= esc( hotel.get("check_out") != null
                                                ? hotel.get("check_out")
                                                : "-" ) %>

                                        </td>


                                        <td>

                                            <form
                                                method="post"
                                                action="<%= esc( request.getContextPath() ) %>/admin/tours"
                                                onsubmit="return confirm('Delete this hotel?');"
                                            ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                                                <input
                                                    type="hidden"
                                                    name="action"
                                                    value="deleteHotel"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="tourId"
                                                    value="<%= esc( selectedTour.get("id") ) %>"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="id"
                                                    value="<%= esc( hotel.get("id") ) %>"
                                                >

                                                <button
                                                    type="submit"
                                                    class="button danger"
                                                >
                                                    Delete
                                                </button>

                                            </form>

                                        </td>

                                    </tr>


                                <% } %>

                                </tbody>

                            </table>

                        </div>


                    <% } else { %>


                        <div class="empty">

                            <div class="empty-icon">
                                +
                            </div>

                            No hotels added yet.

                        </div>


                    <% } %>

                </div>



                <!-- =================================================
                     COVER & GALLERY IMAGES (BLOB)
                ================================================== -->

                <div class="card">

                    <div class="card-header">

                        <div>

                            <h2>
                                Destination photography
                            </h2>

                            <p>
                                Curate the main cover and gallery travellers see across the destination experience.
                            </p>

                        </div>

                    </div>


<%
                    java.util.List<java.util.Map<String,Object>> images =
                        (java.util.List<java.util.Map<String,Object>>) request.getAttribute("images");
                    java.util.Map<String,Object> coverImage = null;
                    if (images != null) {
                        for (java.util.Map<String,Object> candidate : images) {
                            if (Boolean.TRUE.equals(candidate.get("is_cover"))) { coverImage = candidate; break; }
                        }
                    }
                %>
                <div class="destination-photo-studio">
                    <div class="destination-cover-preview <%= coverImage == null ? "is-empty" : "" %>">
                        <% if (coverImage != null) { %>
                        <img id="destination-cover-preview" src="<%= esc(request.getContextPath()) %>/TourImageServlet?id=<%= esc(coverImage.get("id")) %>" alt="<%= esc(selectedTour.get("name")) %> cover" width="720" height="480">
                        <span>Main cover</span>
                        <% } else { %>
                        <div id="destination-cover-placeholder"><b>✦</b><strong>Your destination deserves a beautiful cover.</strong><small>Upload a landscape JPEG or PNG to begin.</small></div>
                        <img id="destination-cover-preview" hidden alt="New destination cover preview">
                        <% } %>
                    </div>
                    <div class="destination-cover-controls">
                        <p class="photo-eyebrow">MAIN PACKAGE IMAGE</p>
                        <h3><%= coverImage == null ? "Add a cover photo" : "Replace the cover photo" %></h3>
                        <p>This is the first image travellers see on the destination card and details page. Replacing it keeps the previous cover in the gallery.</p>
                        <form method="post" action="<%= esc(request.getContextPath()) %>/admin/tours" enctype="multipart/form-data" class="destination-photo-form">
                            <input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>"><input type="hidden" name="action" value="uploadImage"><input type="hidden" name="tourId" value="<%= esc(selectedTour.get("id")) %>"><input type="hidden" name="is_cover" value="true">
                            <label for="destination-cover-file">Choose cover photo</label>
                            <input id="destination-cover-file" type="file" name="image" accept="image/jpeg,image/png" required>
                            <small>JPEG or PNG · up to 5 MB and 24 megapixels. A 3:2 landscape image works best.</small>
                            <button type="submit" class="button primary">Save main cover</button>
                        </form>
                    </div>
                </div>
                <div class="destination-gallery-upload">
                    <div><p class="photo-eyebrow">DESTINATION GALLERY</p><h3>Add another view</h3><p>Show the places, stays and experiences included in this destination.</p></div>
                    <form method="post" action="<%= esc(request.getContextPath()) %>/admin/tours" enctype="multipart/form-data" class="destination-photo-form inline">
                        <input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>"><input type="hidden" name="action" value="uploadImage"><input type="hidden" name="tourId" value="<%= esc(selectedTour.get("id")) %>">
                        <label for="destination-gallery-file">Gallery photo</label><input id="destination-gallery-file" type="file" name="image" accept="image/jpeg,image/png" required>
                        <button type="submit" class="button">Add to gallery</button>
                    </form>
                </div>
                    <% if (images != null &&
                           !images.isEmpty()) { %>


                        <div class="image-grid">


                            <% for (
                                java.util.Map<String,Object> image
                                : images
                            ) { %>


                                <div class="image-card">


                                    <img
                                        src="<%= esc( request.getContextPath() ) %>/TourImageServlet?id=<%= esc( image.get("id") ) %>"
                                        alt="<%= esc( image.get("original_name") ) %>"
                                    >


                                    <div class="image-info">


                                        <strong>
                                            <%= esc( image.get("original_name") ) %>
                                        </strong>


                                        <%
                                            boolean isCover =
                                                Boolean.TRUE.equals(
                                                    image.get("is_cover")
                                                );
                                        %>


                                        <% if (isCover) { %>

                                            <span class="cover">
                                                MAIN COVER
                                            </span>

                                        <% } %>


                                        <div class="image-actions">


                                            <% if (!isCover) { %>


                                                <form
                                                    method="post"
                                                    action="<%= esc( request.getContextPath() ) %>/admin/tours"
                                                ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                                                    <input
                                                        type="hidden"
                                                        name="action"
                                                        value="setCoverImage"
                                                    >

                                                    <input
                                                        type="hidden"
                                                        name="tourId"
                                                        value="<%= esc( selectedTour.get("id") ) %>"
                                                    >

                                                    <input
                                                        type="hidden"
                                                        name="id"
                                                        value="<%= esc( image.get("id") ) %>"
                                                    >

                                                    <button
                                                        type="submit"
                                                        class="button warning"
                                                    >
                                                        Make main cover
                                                    </button>

                                                </form>


                                            <% } %>


                                            <form
                                                method="post"
                                                action="<%= esc( request.getContextPath() ) %>/admin/tours"
                                                onsubmit="return confirm('Delete this image?');"
                                            ><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("tourCsrf")) %>">

                                                <input
                                                    type="hidden"
                                                    name="action"
                                                    value="deleteImage"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="tourId"
                                                    value="<%= esc( selectedTour.get("id") ) %>"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="id"
                                                    value="<%= esc( image.get("id") ) %>"
                                                >

                                                <button
                                                    type="submit"
                                                    class="button danger"
                                                >
                                                    Delete
                                                </button>

                                            </form>


                                        </div>

                                    </div>

                                </div>


                            <% } %>

                        </div>


                    <% } else { %>


                        <div class="empty">

                            <div class="empty-icon">
                                +
                            </div>

                            No destination photos yet. Add the main cover above, then build the gallery.

                        </div>


                    <% } %>

                </div>


            <% } %>


        </main>

    </div>

</div>


<!-- =========================================================
     TOUR SEARCH JAVASCRIPT
========================================================= -->

<script>

    document.addEventListener("DOMContentLoaded", function () {

        const searchInput =
            document.getElementById("tourSearch");

        const clearButton =
            document.getElementById("clearTourSearch");

        const resultCount =
            document.getElementById("searchResultCount");

        const searchEmpty =
            document.getElementById("searchEmpty");

        const tourItems =
            Array.from(
                document.querySelectorAll(".tour-item")
            );


        if (!searchInput || !tourItems.length) {
            return;
        }


        function performTourSearch() {

            const query =
                searchInput.value
                    .trim()
                    .toLowerCase();


            let visibleCount = 0;


            tourItems.forEach(function (tour) {

                const searchableText =
                    (
                        tour.getAttribute("data-tour-search")
                        || ""
                    ).toLowerCase();


                const matches =
                    query === ""
                    ||
                    searchableText.includes(query);


                if (matches) {

                    tour.classList.remove(
                        "search-hidden"
                    );

                    visibleCount++;

                } else {

                    tour.classList.add(
                        "search-hidden"
                    );

                }

            });


            if (query.length > 0) {

                clearButton.style.display = "flex";

            } else {

                clearButton.style.display = "none";

            }


            if (query.length > 0) {

                resultCount.style.display = "block";


                if (visibleCount === 1) {

                    resultCount.textContent =
                        "1 tour package found";

                } else {

                    resultCount.textContent =
                        visibleCount +
                        " tour packages found";

                }

            } else {

                resultCount.style.display = "none";

                resultCount.textContent = "";

            }


            if (
                query.length > 0 &&
                visibleCount === 0
            ) {

                searchEmpty.classList.add(
                    "visible"
                );

            } else {

                searchEmpty.classList.remove(
                    "visible"
                );

            }

        }


        searchInput.addEventListener(
            "input",
            performTourSearch
        );


        clearButton.addEventListener(
            "click",
            function () {

                searchInput.value = "";

                performTourSearch();

                searchInput.focus();

            }
        );


        searchInput.addEventListener(
            "keydown",
            function (event) {

                if (event.key === "Escape") {

                    searchInput.value = "";

                    performTourSearch();

                }

            }
        );

    });

</script>


</body>

</html>