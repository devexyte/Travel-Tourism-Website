<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Destinations | TravelTourism</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/destinations.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/destinations-premium.css">


    <style>

        /* ================================
           SAVED TOUR HEART
           ================================ */

        .tour-image-wrapper {
            position: relative;
        }

        .save-heart {
            position: absolute;

            top: 16px;
            right: 16px;

            width: 38px;
            height: 38px;

            display: grid;
            place-items: center;

            border-radius: 50%;

            background: rgba(255, 255, 255, 0.94);

            color: #193f49;

            text-decoration: none;

            font-size: 23px;
            line-height: 1;

            z-index: 10;

            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);

            transition:
                transform 0.25s ease,
                color 0.25s ease,
                box-shadow 0.25s ease;
        }

        .save-heart:hover {
            transform: scale(1.1);

            box-shadow:
                0 6px 18px rgba(0, 0, 0, 0.20);
        }

        .save-heart.unsaved {
            color: #193f49;
        }

        .save-heart.saved {
            color: #e53935;
        }

        .save-heart.saved:hover {
            color: #c62828;
        }

        /* Make sure the image link doesn't cover the heart */
        .tour-image-wrapper > .tour-image-link {
            display: block;
            width: 100%;
            height: 100%;
        }

    </style>

</head>


<body class="destinations-premium">


    <%@ include file="common/header.jsp" %>


    <main>


        <!-- ==========================================
             HERO / COLLECTION INTRO
             ========================================== -->

        <section class="collection-intro">

            <div class="collection-title">

                <p class="collection-eyebrow">
                    THE INDIA COLLECTION
                </p>

                <h1>
                    Some journeys<br>
                    stay with you.
                </h1>

                <p>
                    Explore our destinations and find the journey
                    that feels like yours.
                </p>

                <a
                    href="#journey-collection"
                    class="collection-discover-link"
                >
                    Discover the collection
                    <span aria-hidden="true">
                        ↓
                    </span>
                </a>

            </div>


            <div class="collection-visual">

                <c:choose>

                    <c:when test="${not empty tours and tours[0].imageId > 0}">

                        <img
                            src="${pageContext.request.contextPath}/TourImageServlet?id=${tours[0].imageId}"
                            alt="<c:out value='${tours[0].name}'/>"
                            fetchpriority="high"
                        >

                        <div class="collection-photo-caption">

                            <span>
                                IN THE COLLECTION
                            </span>

                            <p>
                                <c:out value="${tours[0].name}"/>
                            </p>

                        </div>

                    </c:when>


                    <c:otherwise>

                        <div class="collection-placeholder">

                            <span aria-hidden="true">
                                ⌖
                            </span>

                            <p>
                                Find your next journey
                            </p>

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>

        </section>

        <!-- ==========================================
             DESTINATION COLLECTION
             ========================================== -->

        <section
            class="destinations-layout"
            id="journey-collection"
        >

            <div class="destinations-container">


                <!-- ======================================
                     FILTER PANEL
                     ====================================== -->

                <aside class="filters-panel-modern">

                    <form
                        action="${pageContext.request.contextPath}/destinations"
                        method="get"
                    >


                        <div class="collection-filter-heading">

                            <h2 class="filter-title">
                                Your kind of journey
                            </h2>

                            <a
                                href="${pageContext.request.contextPath}/destinations"
                            >
                                Reset
                            </a>

                        </div>


                        <p class="filter-help">
                            A few preferences. A world of possibilities.
                        </p>


                        <c:if test="${not empty param.place}">

                            <input
                                type="hidden"
                                name="place"
                                value="<c:out value='${param.place}'/>"
                            >

                        </c:if>


                        <!-- DEPARTURE CITY -->

                        <div class="filter-group">

                            <label for="city">
                                Departure city
                            </label>

                            <select
                                name="city"
                                id="city"
                            >

                                <option value="all">
                                    All cities
                                </option>


                                <c:forTokens
                                    var="city"
                                    items="Mumbai,Delhi,Jaipur"
                                    delims=","
                                >

                                    <option
                                        value="${city}"
                                        ${param.city == city ? 'selected' : ''}
                                    >
                                        ${city}
                                    </option>

                                </c:forTokens>

                            </select>

                        </div>


                        <!-- TRAVEL STYLE -->

                        <div class="filter-group">

                            <label for="category">
                                Travel style
                            </label>

                            <select
                                name="category"
                                id="category"
                            >

                                <option value="all">
                                    All travel styles
                                </option>


                                <c:forTokens
                                    var="category"
                                    items="Family,Adventure,Culture,Nature,Beach,Pilgrimage,Wildlife,Luxury"
                                    delims=","
                                >

                                    <option
                                        value="${category}"
                                        ${param.category == category ? 'selected' : ''}
                                    >
                                        ${category}
                                    </option>

                                </c:forTokens>

                            </select>

                        </div>


                        <!-- DURATION -->

                        <div class="filter-group">

                            <label for="duration">
                                Duration
                            </label>

                            <select
                                name="duration"
                                id="duration"
                            >

                                <option value="0">
                                    Any duration
                                </option>


                                <c:forEach
                                    var="days"
                                    begin="5"
                                    end="7"
                                >

                                    <option
                                        value="${days}"
                                        ${param.duration == days ? 'selected' : ''}
                                    >
                                        ${days} days
                                    </option>

                                </c:forEach>

                            </select>

                        </div>


                        <!-- PRICE -->

                        <fieldset class="collection-price-filter">

                            <legend>
                                Price per person (₹)
                            </legend>


                            <div class="collection-price-inputs">


                                <div>

                                    <label for="price_min">
                                        Minimum
                                    </label>

                                    <input
                                        type="number"
                                        id="price_min"
                                        name="price_min"
                                        min="0"
                                        placeholder="Any"
                                        value="<c:out value='${param.price_min}'/>"
                                    >

                                </div>


                                <div>

                                    <label for="price_max">
                                        Maximum
                                    </label>

                                    <input
                                        type="number"
                                        id="price_max"
                                        name="price_max"
                                        min="0"
                                        placeholder="Any"
                                        value="<c:out value='${param.price_max}'/>"
                                    >

                                </div>


                            </div>

                        </fieldset>


                        <button
                            type="submit"
                            class="filter-btn"
                        >

                            Find my journey

                            <span aria-hidden="true">
                                ↗
                            </span>

                        </button>


                    </form>

                </aside>



                <!-- ======================================
                     RESULTS
                     ====================================== -->

                <div class="results-panel-modern">


                    <div class="results-toolbar">

                        <div>

                            <p class="eyebrow">
                                EXPLORE AT YOUR OWN PACE
                            </p>

                            <h2>
                                ${resultCount} journeys to discover
                            </h2>

                        </div>


                        <a
                            id="compare-button"
                            class="compare-button is-disabled"
                            aria-disabled="true"
                            href="#"
                        >

                            Compare selected

                            <span>
                                0
                            </span>

                        </a>

                    </div>


                    <c:if test="${not empty param.place}">

                        <p class="collection-search-note">

                            Showing matches for
                            “<c:out value="${param.place}"/>”

                        </p>

                    </c:if>


                    <p
                        class="collection-compare-help"
                        id="compare-help"
                    >
                        Select up to three journeys to compare their details.
                    </p>



                    <!-- ==================================
                         TOUR GRID
                         ================================== -->

                    <div class="collection-grid">


                        <c:forEach
                            var="tour"
                            items="${tours}"
                        >


                            <article class="tour-card-modern">


                                <!-- IMAGE -->

                                <div class="tour-image-wrapper">


                                    <a
                                        class="tour-image-link"
                                        href="${pageContext.request.contextPath}/tour-details?id=${tour.id}"
                                        aria-label="View details of <c:out value='${tour.name}'/>"
                                    >


                                        <c:choose>

                                            <c:when test="${tour.imageId > 0}">

                                                <img
                                                    src="${pageContext.request.contextPath}/TourImageServlet?id=${tour.imageId}"
                                                    alt="<c:out value='${tour.name}'/>"
                                                    loading="lazy"
                                                >

                                            </c:when>


                                            <c:otherwise>

                                                <div class="tour-image-placeholder">
                                                    Tour photograph not available
                                                </div>

                                            </c:otherwise>

                                        </c:choose>


                                        <span class="collection-category">

                                            <c:out value="${tour.category}"/>

                                        </span>


                                        <span
                                            class="collection-image-arrow"
                                            aria-hidden="true"
                                        >
                                            ↗
                                        </span>


                                    </a>



                                    <!-- SAVED TOUR HEART -->

                                    <c:choose>

                                        <c:when test="${savedTourIds[tour.id]}">

                                            <a
                                                class="save-heart saved"
                                                href="${pageContext.request.contextPath}/remove-saved-tour?tour_id=${tour.id}&tour_type=destination&return_url=/destinations"
                                                title="Remove from Saved Tours"
                                                aria-label="Remove ${tour.name} from Saved Tours"
                                            >
                                                ♥
                                            </a>

                                        </c:when>


                                        <c:otherwise>

                                            <a
                                                class="save-heart unsaved"
                                                href="${pageContext.request.contextPath}/save-tour?tour_id=${tour.id}&tour_type=destination&return_url=/destinations"
                                                title="Save Tour"
                                                aria-label="Save ${tour.name} to Saved Tours"
                                            >
                                                ♡
                                            </a>

                                        </c:otherwise>

                                    </c:choose>


                                </div>



                                <!-- TOUR CONTENT -->

                                <div class="tour-content">


                                    <div class="tour-meta-row">

                                        <span>
                                            ${tour.duration} DAYS
                                        </span>

                                        <span>
                                            FROM
                                            <c:out value="${tour.departureCity}"/>
                                        </span>

                                    </div>


                                    <h3>

                                        <a
                                            href="${pageContext.request.contextPath}/tour-details?id=${tour.id}"
                                        >
                                            <c:out value="${tour.name}"/>
                                        </a>

                                    </h3>


                                    <c:if test="${not empty tour.shortDescription}">

                                        <p class="tour-description">

                                            <c:out value="${tour.shortDescription}"/>

                                        </p>

                                    </c:if>


                                    <div class="collection-card-footer">


                                        <p class="tour-price">

                                            ₹<fmt:formatNumber
                                                value="${tour.price}"
                                                groupingUsed="true"
                                            />

                                            <small>
                                                per person
                                            </small>

                                        </p>


                                        <a
                                            class="primary-btn-small"
                                            href="${pageContext.request.contextPath}/tour-details?id=${tour.id}"
                                        >

                                            View Details

                                            <span aria-hidden="true">
                                                ↗
                                            </span>

                                        </a>


                                    </div>


                                    <div class="tour-actions">


                                        <label class="compare-label">

                                            <input
                                                class="tour-check"
                                                type="checkbox"
                                                value="${tour.id}"
                                                aria-describedby="compare-help"
                                            >

                                            Compare

                                            <span class="collection-sr-only">

                                                <c:out value="${tour.name}"/>

                                            </span>

                                        </label>


                                        <a
                                            href="${pageContext.request.contextPath}/contact?tour_id=${tour.id}"
                                        >
                                            Enquire about this tour
                                        </a>


                                    </div>


                                </div>


                            </article>


                        </c:forEach>


                    </div>



                    <!-- NO RESULTS -->

                    <c:if test="${empty tours}">

                        <div class="no-results">

                            <p class="eyebrow">
                                ROOM TO EXPLORE
                            </p>

                            <h3>
                                No journeys match those filters.
                            </h3>

                            <p>
                                Try another departure city,
                                travel style or price range.
                            </p>

                            <a
                                href="${pageContext.request.contextPath}/destinations"
                            >
                                Explore all journeys ↗
                            </a>

                        </div>

                    </c:if>


                    <p
                        id="compare-status"
                        class="collection-sr-only"
                        aria-live="polite"
                    ></p>


                </div>

            </div>

        </section>

    </main>


    <%@ include file="common/footer.jsp" %>


    <!-- ==========================================
         COMPARE TOURS JAVASCRIPT
         ========================================== -->

    <script>

        (() => {

            const checks = [
                ...document.querySelectorAll('.tour-check')
            ];

            const button =
                document.getElementById('compare-button');


            function update() {

                const ids = [
                    ...new Set(
                        checks
                            .filter(check => check.checked)
                            .map(check => check.value)
                    )
                ];


                checks.forEach(check => {

                    check.disabled =
                        ids.length >= 3 && !check.checked;

                });


                button.querySelector('span').textContent =
                    ids.length;


                button.href =
                    ids.length
                        ? '${pageContext.request.contextPath}/compare-tours?ids='
                          + ids.join(',')
                        : '#';


                button.classList.toggle(
                    'is-disabled',
                    !ids.length
                );


                button.setAttribute(
                    'aria-disabled',
                    String(!ids.length)
                );


                document.getElementById(
                    'compare-status'
                ).textContent =
                    ids.length +
                    ' journeys selected.' +
                    (
                        ids.length >= 3
                            ? ' Deselect one to choose another.'
                            : ''
                    );

            }


            button.addEventListener(
                'click',
                event => {

                    if (
                        button.getAttribute('aria-disabled')
                        === 'true'
                    ) {

                        event.preventDefault();

                    }

                }
            );


            checks.forEach(
                check =>
                    check.addEventListener(
                        'change',
                        update
                    )
            );


            update();
        })();

    </script>


</body>

</html>