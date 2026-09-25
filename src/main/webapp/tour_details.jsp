<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>
        <c:out value="${tour.name}"/> | TravelTourism
    </title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/tour_details.css?v=c6940c917971">

</head>


<body class="journey-page">


<%@ include file="common/header.jsp" %>


<main class="journey-shell">


    <!-- ================= BREADCRUMB ================= -->

    <nav class="journey-breadcrumb"
         aria-label="Breadcrumb">

        <a href="${pageContext.request.contextPath}/index.jsp">
            Home
        </a>

        <span aria-hidden="true">
            /
        </span>

        <a href="${pageContext.request.contextPath}/destinations">
            Destinations
        </a>

        <span aria-hidden="true">
            /
        </span>

        <span aria-current="page">

            <c:out value="${tour.name}"/>

        </span>

    </nav>


    <!-- ================= OPENING ================= -->

    <div class="journey-opening">


        <header class="journey-heading">

            <div>

                <p class="journey-kicker">

                    <span></span>

                    <c:out value="${tour.category}"/>

                    · INDIA

                </p>


                <h1>

                    <c:out value="${tour.name}"/>

                </h1>


                <c:if test="${not empty tour.shortDescription}">

                    <p class="journey-lead">

                        <c:out value="${tour.shortDescription}"/>

                    </p>

                </c:if>

            </div>


            <a class="journey-text-link"
               href="#itinerary-section">

                Discover the itinerary

                <span aria-hidden="true">
                    ↗
                </span>

            </a>

        </header>


        <!-- ================= HERO IMAGE ================= -->

        <section class="journey-hero"
                 aria-label="Tour photograph">


            <c:choose>

                <c:when test="${tour.imageId > 0}">

                    <img
                        src="${pageContext.request.contextPath}/TourImageServlet?id=${tour.imageId}"
                        alt="<c:out value='${tour.name}'/>"
                        fetchpriority="high">

                </c:when>


                <c:otherwise>

                    <div class="journey-image-empty">

                        <span aria-hidden="true">
                            ⌖
                        </span>

                        <p>
                            Tour photograph not available
                        </p>

                    </div>

                </c:otherwise>

            </c:choose>


            <div class="journey-hero-caption">

                <span>
                    THE JOURNEY
                </span>

                <p>

                    <c:out value="${tour.departureCity}"/>

                    <span aria-hidden="true">
                        —
                    </span>

                    ${tour.duration} days

                </p>

            </div>


            <c:if test="${not empty images}">

                <a class="journey-gallery-link"
                   href="#gallery-section">

                    <span aria-hidden="true">
                        ▦
                    </span>

                    Explore gallery

                    <span>
                        ${fn:length(images)}
                    </span>

                </a>

            </c:if>


        </section>

    </div>


    <!-- ================= FACTS ================= -->

    <div class="journey-facts"
         aria-label="Tour at a glance">


        <div>

            <span class="journey-fact-label">
                DURATION
            </span>

            <strong>
                ${tour.duration} days
            </strong>

        </div>


        <div>

            <span class="journey-fact-label">
                DEPARTING FROM
            </span>

            <strong>
                <c:out value="${tour.departureCity}"/>
            </strong>

        </div>


        <div>

            <span class="journey-fact-label">
                TRAVEL STYLE
            </span>

            <strong>
                <c:out value="${tour.category}"/>
            </strong>

        </div>


        <div>

            <span class="journey-fact-label">
                BEST TIME TO VISIT
            </span>

            <strong>
                <c:out value="${empty details.bestTime ? 'Not specified' : details.bestTime}"/>
            </strong>

        </div>


    </div>


    <!-- ================= SECTION NAV ================= -->

    <nav class="journey-section-nav"
         aria-label="Tour sections">

        <a href="#overview-section">
            Overview
        </a>

        <a href="#itinerary-section">
            Itinerary
        </a>

        <a href="#stays-section">
            Stays
        </a>

        <a href="#essentials-section">
            What's included
        </a>

        <a href="#gallery-section">
            Gallery
        </a>

        <a href="#map-section">
            Location
        </a>

    </nav>


    <div class="journey-layout">


        <!-- ================= STORY ================= -->

        <div class="journey-story">


            <!-- OVERVIEW -->

            <section class="journey-section"
                     id="overview-section">

                <p class="journey-kicker">
                    01 / THE EXPERIENCE
                </p>

                <h2>
                    A closer look at your journey.
                </h2>


                <p class="journey-copy">

                    <c:out value="${empty details.longDescription
                        ? 'Details are not available for this tour yet.'
                        : details.longDescription}"/>

                </p>


                <c:if test="${not empty details.highlights}">

                    <div class="journey-highlights">

                        <h3>
                            Journey highlights
                        </h3>

                        <ul>

                            <c:forEach
                                var="highlight"
                                items="${fn:split(details.highlights, ',')}">

                                <li>

                                    <span aria-hidden="true">
                                        ✦
                                    </span>

                                    <c:out value="${fn:trim(highlight)}"/>

                                </li>

                            </c:forEach>

                        </ul>

                    </div>

                </c:if>


                <c:if test="${empty details.highlights}">

                    <p class="journey-muted">
                        Tour highlights are not available yet.
                    </p>

                </c:if>

            </section>


            <!-- ITINERARY -->

            <section class="journey-section"
                     id="itinerary-section">


                <div class="journey-section-heading">

                    <div>

                        <p class="journey-kicker">
                            02 / THE ITINERARY
                        </p>

                        <h2>
                            Every day, a new perspective.
                        </h2>

                    </div>

                    <span class="journey-duration">
                        ${tour.duration} days
                    </span>

                </div>


                <c:choose>

                    <c:when test="${not empty itinerary}">

                        <div class="journey-timeline">

                            <c:forEach
                                var="day"
                                items="${itinerary}"
                                varStatus="status">

                                <details class="journey-day"
                                         ${status.first ? 'open' : ''}>

                                    <summary>

                                        <span class="journey-day-label">

                                            DAY

                                            <fmt:formatNumber
                                                value="${day.dayNumber}"
                                                pattern="00"/>

                                        </span>

                                        <span>

                                            <c:out value="${day.dayTitle}"/>

                                        </span>

                                        <span class="journey-expand"
                                              aria-hidden="true">

                                            +

                                        </span>

                                    </summary>


                                    <p class="journey-copy">

                                        <c:out value="${day.dayDescription}"/>

                                    </p>

                                </details>

                            </c:forEach>

                        </div>

                    </c:when>


                    <c:otherwise>

                        <p class="journey-muted">
                            Itinerary information is not available yet.
                        </p>

                    </c:otherwise>

                </c:choose>

            </section>


            <!-- STAYS -->

            <section class="journey-section"
                     id="stays-section">

                <p class="journey-kicker">
                    03 / YOUR STAYS
                </p>

                <h2>
                    A place to pause.
                </h2>


                <c:choose>

                    <c:when test="${not empty hotels}">

                        <div class="journey-stays">

                            <c:forEach var="hotel"
                                       items="${hotels}">

                                <article class="journey-hotel">

                                    <div class="journey-hotel-icon"
                                         aria-hidden="true">
                                        ⌂
                                    </div>

                                    <div>

                                        <p class="journey-kicker">

                                            <c:out value="${hotel.city}"/>

                                        </p>

                                        <h3>

                                            <c:out value="${hotel.hotelName}"/>

                                        </h3>


                                        <div class="journey-hotel-dates">

                                            <p>

                                                <span>
                                                    Check-in
                                                </span>

                                                <c:out value="${hotel.checkIn}"/>

                                            </p>


                                            <p>

                                                <span>
                                                    Check-out
                                                </span>

                                                <c:out value="${hotel.checkOut}"/>

                                            </p>

                                        </div>

                                    </div>

                                </article>

                            </c:forEach>

                        </div>

                    </c:when>


                    <c:otherwise>

                        <p class="journey-muted">
                            Accommodation information is not available yet.
                        </p>

                    </c:otherwise>

                </c:choose>

            </section>


            <!-- DETAILS -->

            <section class="journey-section"
                     id="essentials-section">

                <p class="journey-kicker">
                    04 / THE DETAILS
                </p>

                <h2>
                    Know before you go.
                </h2>


                <div class="journey-inclusions-grid">


                    <div class="journey-included">

                        <h3>

                            <span aria-hidden="true">
                                +
                            </span>

                            Included in your journey

                        </h3>


                        <c:choose>

                            <c:when test="${not empty details.inclusions}">

                                <ul>

                                    <c:forEach
                                        var="item"
                                        items="${fn:split(details.inclusions, ',')}">

                                        <li>
                                            <c:out value="${fn:trim(item)}"/>
                                        </li>

                                    </c:forEach>

                                </ul>

                            </c:when>


                            <c:otherwise>

                                <p class="journey-muted">
                                    Inclusion information is not available yet.
                                </p>

                            </c:otherwise>

                        </c:choose>

                    </div>


                    <div class="journey-excluded">

                        <h3>

                            <span aria-hidden="true">
                                −
                            </span>

                            Not included

                        </h3>


                        <c:choose>

                            <c:when test="${not empty details.exclusions}">

                                <ul>

                                    <c:forEach
                                        var="item"
                                        items="${fn:split(details.exclusions, ',')}">

                                        <li>
                                            <c:out value="${fn:trim(item)}"/>
                                        </li>

                                    </c:forEach>

                                </ul>

                            </c:when>


                            <c:otherwise>

                                <p class="journey-muted">
                                    Exclusion information is not available yet.
                                </p>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>


                <div class="journey-practical">


                    <details>

                        <summary>

                            Preparing for your trip

                            <span aria-hidden="true">
                                +
                            </span>

                        </summary>

                        <p class="journey-copy">

                            <c:out value="${empty details.preparation
                                ? 'Preparation information is not available yet.'
                                : details.preparation}"/>

                        </p>

                    </details>


                    <details>

                        <summary>

                            Payment terms

                            <span aria-hidden="true">
                                +
                            </span>

                        </summary>

                        <p class="journey-copy">

                            <c:out value="${empty details.paymentTerms
                                ? 'Payment terms are not available yet.'
                                : details.paymentTerms}"/>

                        </p>

                    </details>


                    <details>

                        <summary>

                            Available upgrades

                            <span aria-hidden="true">
                                +
                            </span>

                        </summary>

                        <p class="journey-copy">

                            <c:out value="${empty details.upgradesInfo
                                ? 'No upgrade information is available yet.'
                                : details.upgradesInfo}"/>

                        </p>

                    </details>


                </div>

            </section>


            <!-- GALLERY -->

            <section class="journey-section"
                     id="gallery-section">

                <p class="journey-kicker">
                    05 / THROUGH THE LENS
                </p>

                <h2>
                    A glimpse of what's ahead.
                </h2>


                <c:choose>

                    <c:when test="${not empty images}">

                        <div class="journey-gallery">

                            <c:forEach
                                var="photo"
                                items="${images}"
                                varStatus="status">

                                <c:if test="${photo.id > 0}">

                                    <a class="journey-photo"
                                       href="${pageContext.request.contextPath}/TourImageServlet?id=${photo.id}"
                                       aria-label="View photo ${status.count} of <c:out value='${tour.name}'/>">

                                        <img
                                            src="${pageContext.request.contextPath}/TourImageServlet?id=${photo.id}"
                                            loading="lazy"
                                            alt="<c:out value='${tour.name}'/> — photo ${status.count}">

                                        <span aria-hidden="true">
                                            ↗
                                        </span>

                                    </a>

                                </c:if>

                            </c:forEach>

                        </div>

                    </c:when>


                    <c:otherwise>

                        <p class="journey-muted">
                            No gallery images have been uploaded for this tour yet.
                        </p>

                    </c:otherwise>

                </c:choose>

            </section>


            <!-- MAP -->

            <section class="journey-section"
                     id="map-section">

                <p class="journey-kicker">
                    06 / ON THE MAP
                </p>

                <h2>
                    Find your bearings.
                </h2>


                <c:choose>

                    <c:when test="${not empty details.mapEmbed}">

                        <iframe
                            class="journey-map"
                            src="<c:out value='${details.mapEmbed}'/>"
                            title="Location map for <c:out value='${tour.name}'/>"
                            loading="lazy"
                            referrerpolicy="no-referrer-when-downgrade"
                            allowfullscreen>
                        </iframe>

                        <div class="journey-map-footer" style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                            <span class="journey-muted" style="font-size: 13px;">
                                Interactive destination map &amp; route exploration
                            </span>
                            <a href="<c:out value='${details.mapEmbed}'/>" target="_blank" rel="noopener noreferrer" class="journey-text-link" style="font-size: 13px; text-decoration: underline;">
                                Open full map in new tab ↗
                            </a>
                        </div>

                    </c:when>


                    <c:otherwise>

                        <p class="journey-muted">
                            Location map is not available yet.
                        </p>

                    </c:otherwise>

                </c:choose>

            </section>


        </div>


        <!-- ================= BOOKING SIDEBAR ================= -->

        <aside class="journey-booking"
               aria-label="Tour price and booking">


            <p class="journey-kicker">
                MAKE THIS JOURNEY YOURS
            </p>


            <p class="journey-price">

                ₹<fmt:formatNumber
                    value="${tour.price}"
                    groupingUsed="true"/>

            </p>


            <p class="journey-price-caption">
                per person
            </p>


            <div class="journey-booking-rule"></div>


            <dl>


                <div>

                    <dt>
                        Duration
                    </dt>

                    <dd>
                        ${tour.duration} days
                    </dd>

                </div>


                <div>

                    <dt>
                        Departure
                    </dt>

                    <dd>
                        <c:out value="${tour.departureCity}"/>
                    </dd>

                </div>


                <div>

                    <dt>
                        Travel style
                    </dt>

                    <dd>
                        <c:out value="${tour.category}"/>
                    </dd>

                </div>


            </dl>


            <!-- EXISTING BOOKING BUTTON -->

            <a class="journey-primary"
               href="${pageContext.request.contextPath}/booking?tour_id=${tour.id}">

                Book this tour

                <span aria-hidden="true">
                    ↗
                </span>

            </a>


            <!-- NEW SAVE TOUR BUTTON -->

            <a class="journey-secondary"
               href="${pageContext.request.contextPath}/save-tour?tour_id=${tour.id}&tour_type=destination">

                ♡ Save Tour

            </a>


            <!-- EXISTING ENQUIRY BUTTON -->

            <a class="journey-secondary"
               href="${pageContext.request.contextPath}/contact?tour_id=${tour.id}">

                Enquire about this journey

            </a>


            <a class="journey-booking-foot"
               href="#essentials-section">

                Review inclusions &amp; payment terms

                <span aria-hidden="true">
                    ↓
                </span>

            </a>


        </aside>


    </div>


    <!-- ================= BOTTOM ================= -->

    <div class="journey-bottom">


        <div>

            <p class="journey-kicker">
                KEEP EXPLORING
            </p>

            <h2>
                Where will you go next?
            </h2>

        </div>


        <a class="journey-secondary"
           href="${pageContext.request.contextPath}/destinations">

            Explore all destinations

            <span aria-hidden="true">
                ↗
            </span>

        </a>

    </div>


</main>


<!-- ================= LIGHTBOX ================= -->

<dialog class="journey-lightbox"
        aria-label="Tour photo viewer">

    <button class="journey-lightbox-close"
            type="button"
            aria-label="Close photo viewer">

        ×

    </button>


    <img alt="">


    <div class="journey-lightbox-controls">

        <button type="button"
                data-direction="-1"
                aria-label="Previous photo">

            ←

        </button>


        <p aria-live="polite"></p>


        <button type="button"
                data-direction="1"
                aria-label="Next photo">

            →

        </button>

    </div>

</dialog>


<%@ include file="common/footer.jsp" %>


<script
    src="${pageContext.request.contextPath}/js/tour-details.js?v=9ecbbec20db6"
    defer>
</script>


</body>
</html>