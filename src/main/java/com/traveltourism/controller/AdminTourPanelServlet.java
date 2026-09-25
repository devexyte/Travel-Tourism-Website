package com.traveltourism.controller;

import com.traveltourism.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import java.sql.Statement;
import java.sql.Types;

@WebServlet(
    name = "AdminTourPanelServlet",
    urlPatterns = {"/admin/tours"}
)
@MultipartConfig(
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 50 * 1024 * 1024
)
public class AdminTourPanelServlet extends HttpServlet {

    // =============================================================
    // GET
    // =============================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (request.getSession().getAttribute("tourCsrf") == null) {
            request.getSession().setAttribute("tourCsrf", java.util.UUID.randomUUID().toString());
        }
        Integer selectedTourId =
                parseInteger(request.getParameter("tourId"));

        try (Connection connection = DBConnection.getConnection()) {

            // =====================================================
            // LOAD ALL TOURS
            // =====================================================

            List<Map<String, Object>> tours =
                    loadTours(connection);

            request.setAttribute("tours", tours);

            // =====================================================
            // LOAD SELECTED TOUR
            // =====================================================

            if (selectedTourId != null) {

                Map<String, Object> selectedTour =
                        loadTour(
                                connection,
                                selectedTourId
                        );

                if (selectedTour != null) {

                    request.setAttribute(
                            "selectedTour",
                            selectedTour
                    );

                    request.setAttribute(
                            "tourDetails",
                            loadTourDetails(
                                    connection,
                                    selectedTourId
                            )
                    );

                    request.setAttribute(
                            "itinerary",
                            loadItinerary(
                                    connection,
                                    selectedTourId
                            )
                    );

                    request.setAttribute(
                            "hotels",
                            loadHotels(
                                    connection,
                                    selectedTourId
                            )
                    );

                    request.setAttribute(
                            "images",
                            loadImages(
                                    connection,
                                    selectedTourId
                            )
                    );
                }
            }

            // =====================================================
            // FLASH MESSAGE
            // =====================================================

            String message =
                    (String) request.getSession()
                            .getAttribute("adminMessage");

            if (message != null) {

                request.setAttribute(
                        "adminMessage",
                        message
                );

                request.getSession()
                        .removeAttribute("adminMessage");
            }

            // =====================================================
            // FORWARD TO JSP
            // =====================================================

            request.setAttribute("adminSection", "tours");
            request.getRequestDispatcher(
                    "/admin/admin-tour-management.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load admin tour management panel",
                    e
            );
        }
    }


    // =============================================================
    // POST
    // =============================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (request.getSession(false) == null || request.getParameter("csrf") == null
                || !request.getParameter("csrf").equals(request.getSession().getAttribute("tourCsrf"))) {
            response.sendError(403, "Please reload the admin panel before saving.");
            return;
        }

        String action = request.getParameter("action");

        if (action != null) {
            action = action.trim();
        }

        Integer tourId =
                parseInteger(
                        request.getParameter("tourId")
                );

        try (Connection connection = DBConnection.getConnection()) {

            // =====================================================
            // NO ACTION
            // =====================================================

            if (action == null || action.isEmpty()) {

                setMessage(
                        request,
                        "No admin action was specified."
                );

            // =====================================================
            // CREATE NEW TOUR
            // =====================================================

            } else if ("createTour".equalsIgnoreCase(action)) {

                int newTourId =
                        createTour(
                                connection,
                                request
                        );

                setMessage(
                        request,
                        "Tour package created successfully."
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/tours?tourId="
                                + newTourId
                );

                return;

            // =====================================================
            // UPDATE MAIN TOUR
            // =====================================================

            } else if ("updateTour".equalsIgnoreCase(action)) {

                updateTour(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Tour information updated successfully."
                );

            // =====================================================
            // UPDATE / SAVE TOUR DETAILS
            // =====================================================

            } else if (
                    "saveDetails".equalsIgnoreCase(action)
                            ||
                    "updateDetails".equalsIgnoreCase(action)
            ) {

                updateTourDetails(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Tour details updated successfully."
                );

            // =====================================================
            // ADD ITINERARY
            // =====================================================

            } else if ("addItinerary".equalsIgnoreCase(action)) {

                addItinerary(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Itinerary day added successfully."
                );

            // =====================================================
            // UPDATE ITINERARY
            // =====================================================

            } else if ("updateItinerary".equalsIgnoreCase(action)) {

                updateItinerary(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Itinerary day updated successfully."
                );

            // =====================================================
            // DELETE ITINERARY
            // =====================================================

            } else if ("deleteItinerary".equalsIgnoreCase(action)) {

                deleteItinerary(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Itinerary day deleted successfully."
                );

            // =====================================================
            // ADD HOTEL
            // =====================================================

            } else if ("addHotel".equalsIgnoreCase(action)) {

                addHotel(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Hotel added successfully."
                );

            // =====================================================
            // UPDATE HOTEL
            // =====================================================

            } else if ("updateHotel".equalsIgnoreCase(action)) {

                updateHotel(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Hotel updated successfully."
                );

            // =====================================================
            // DELETE HOTEL
            // =====================================================

            } else if ("deleteHotel".equalsIgnoreCase(action)) {

                deleteHotel(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Hotel deleted successfully."
                );

            // =====================================================
            // UPLOAD IMAGE
            // =====================================================

            } else if ("uploadImage".equalsIgnoreCase(action)) {

                uploadImage(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "true".equalsIgnoreCase(getParameter(request, "isCover", "is_cover")) ? "Main cover photo saved." : "Gallery photo added."
                );

            // =====================================================
            // DELETE IMAGE
            // =====================================================

            } else if ("deleteImage".equalsIgnoreCase(action)) {

                deleteImage(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Image deleted successfully."
                );

            // =====================================================
            // SET COVER IMAGE
            // =====================================================

            } else if (
                    "setCover".equalsIgnoreCase(action)
                            ||
                    "setCoverImage".equalsIgnoreCase(action)
            ) {

                setCoverImage(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Cover image updated successfully."
                );

            // =====================================================
            // DELETE ENTIRE TOUR
            // =====================================================

            } else if ("deleteTour".equalsIgnoreCase(action)) {

                deleteTour(
                        connection,
                        request
                );

                setMessage(
                        request,
                        "Tour package deleted successfully."
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/tours"
                );

                return;

            // =====================================================
            // UNKNOWN ACTION
            // =====================================================

            } else {

                setMessage(
                        request,
                        "Unknown admin action: " + action
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            setMessage(
                    request,
                    "Operation failed: " + getSafeErrorMessage(e)
            );
        }

        // =========================================================
        // REDIRECT BACK TO SAME TOUR
        // =========================================================

        if (tourId != null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tours?tourId="
                            + tourId
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tours"
            );
        }
    }


    // =============================================================
    // CREATE TOUR
    // =============================================================

    private int createTour(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        String name =
                clean(request.getParameter("name"));

        String category =
                clean(request.getParameter("category"));

        String departureCity =
                getParameter(
                        request,
                        "departureCity",
                        "departure_city"
                );

        departureCity = clean(departureCity);

        String durationValue =
                clean(request.getParameter("duration"));

        String priceValue =
                clean(request.getParameter("price"));

        String status =
                clean(request.getParameter("status"));

        // =========================================================
        // VALIDATION
        // =========================================================

        if (name == null) {
            throw new Exception(
                    "Tour name is required."
            );
        }

        if (category == null) {
            throw new Exception(
                    "Tour category is required."
            );
        }

        if (departureCity == null) {
            throw new Exception(
                    "Departure city is required."
            );
        }

        if (durationValue == null) {
            throw new Exception(
                    "Duration is required."
            );
        }

        if (priceValue == null) {
            throw new Exception(
                    "Price is required."
            );
        }

        // =========================================================
        // PARSE DURATION
        // =========================================================

        int duration;

        try {

            duration =
                    Integer.parseInt(
                            durationValue
                    );

        } catch (NumberFormatException e) {

            throw new Exception(
                    "Invalid duration. Please enter a whole number."
            );
        }

        if (duration <= 0) {

            throw new Exception(
                    "Duration must be greater than zero."
            );
        }

        // =========================================================
        // PARSE PRICE
        // =========================================================

        BigDecimal price;

        try {

            price =
                    new BigDecimal(
                            priceValue
                    );

        } catch (NumberFormatException e) {

            throw new Exception(
                    "Invalid price. Please enter a valid amount."
            );
        }

        if (price.compareTo(BigDecimal.ZERO) < 0) {

            throw new Exception(
                    "Price cannot be negative."
            );
        }

        // =========================================================
        // STATUS
        // =========================================================

        if (status == null) {
            status = "active";
        }

        if (!"active".equalsIgnoreCase(status)
                &&
            !"inactive".equalsIgnoreCase(status)) {

            throw new Exception(
                    "Invalid tour status."
            );
        }

        status = status.toLowerCase();

        // =========================================================
        // CURRENT TOURS TABLE
        //
        // IMPORTANT:
        // The image column was removed from tours.
        //
        // Current columns being inserted:
        // name
        // category
        // departure_city
        // duration
        // price
        // status
        //
        // created_at and updated_at are automatic.
        // =========================================================

        String sql =
                "INSERT INTO tours " +
                "(name, category, departure_city, " +
                "duration, price, status, short_description) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(
                             sql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setString(
                    1,
                    name
            );

            statement.setString(
                    2,
                    category
            );

            statement.setString(
                    3,
                    departureCity
            );

            statement.setInt(
                    4,
                    duration
            );

            statement.setBigDecimal(
                    5,
                    price
            );

            statement.setString(
                    6,
                    status
            );

            statement.setString(7, clean(request.getParameter("short_description")));
            int affectedRows =
                    statement.executeUpdate();

            if (affectedRows == 0) {

                throw new Exception(
                        "Tour package could not be created."
                );
            }

            // =====================================================
            // GET GENERATED TOUR ID
            // =====================================================

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                if (keys.next()) {

                    return keys.getInt(1);
                }
            }
        }

        throw new Exception(
                "Tour package was inserted but its generated ID could not be retrieved."
        );
    }


    // =============================================================
    // UPDATE MAIN TOUR
    // =============================================================

    private void updateTour(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int tourId =
                requiredInt(
                        request.getParameter("tourId")
                );

        String name =
                clean(request.getParameter("name"));

        String category =
                clean(request.getParameter("category"));

        String departureCity =
                getParameter(
                        request,
                        "departureCity",
                        "departure_city"
                );

        departureCity = clean(departureCity);

        String durationValue =
                clean(request.getParameter("duration"));

        String priceValue =
                clean(request.getParameter("price"));

        String status =
                clean(request.getParameter("status"));

        if (name == null) {
            throw new Exception("Tour name is required.");
        }

        if (category == null) {
            throw new Exception("Tour category is required.");
        }

        if (departureCity == null) {
            throw new Exception("Departure city is required.");
        }

        if (durationValue == null) {
            throw new Exception("Duration is required.");
        }

        if (priceValue == null) {
            throw new Exception("Price is required.");
        }

        int duration;

        try {

            duration =
                    Integer.parseInt(
                            durationValue
                    );

        } catch (NumberFormatException e) {

            throw new Exception(
                    "Invalid duration."
            );
        }

        if (duration <= 0) {

            throw new Exception(
                    "Duration must be greater than zero."
            );
        }

        BigDecimal price;

        try {

            price =
                    new BigDecimal(
                            priceValue
                    );

        } catch (NumberFormatException e) {

            throw new Exception(
                    "Invalid price."
            );
        }

        if (price.compareTo(BigDecimal.ZERO) < 0) {

            throw new Exception(
                    "Price cannot be negative."
            );
        }

        if (status == null) {
            status = "active";
        }

        if (!"active".equalsIgnoreCase(status)
                &&
            !"inactive".equalsIgnoreCase(status)) {

            throw new Exception(
                    "Invalid tour status."
            );
        }

        status = status.toLowerCase();

        String sql =
                "UPDATE tours SET " +
                "name = ?, " +
                "category = ?, " +
                "departure_city = ?, " +
                "duration = ?, " +
                "price = ?, " +
                "status = ?, short_description = ? " +
                "WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, name);
            statement.setString(2, category);
            statement.setString(3, departureCity);
            statement.setInt(4, duration);
            statement.setBigDecimal(5, price);
            statement.setString(6, status);
            statement.setString(7, clean(request.getParameter("short_description")));
            statement.setInt(8, tourId);

            int updated =
                    statement.executeUpdate();

            if (updated == 0) {

                throw new Exception(
                        "Tour package not found."
                );
            }
        }
    }


    // =============================================================
    // UPDATE TOUR DETAILS
    // =============================================================

    private void updateTourDetails(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int tourId =
                requiredInt(
                        request.getParameter("tourId")
                );

        ensureTourExists(
                connection,
                tourId
        );

        String longDescription =
                getParameter(
                        request,
                        "longDescription",
                        "long_description"
                );

        String highlights =
                request.getParameter("highlights");

        String inclusions =
                request.getParameter("inclusions");

        String exclusions =
                request.getParameter("exclusions");

        String bestTime =
                getParameter(
                        request,
                        "bestTime",
                        "best_time"
                );

        String mapEmbed =
                getParameter(
                        request,
                        "mapEmbed",
                        "map_embed"
                );

        String durationText =
                getParameter(
                        request,
                        "durationText",
                        "duration_text"
                );

        String statesCovered =
                getParameter(
                        request,
                        "statesCovered",
                        "states_covered"
                );

        String citiesCovered =
                getParameter(
                        request,
                        "citiesCovered",
                        "cities_covered"
                );

        String route =
                request.getParameter("route");

        String preparation =
                request.getParameter("preparation");

        String paymentTerms =
                getParameter(
                        request,
                        "paymentTerms",
                        "payment_terms"
                );

        String upgradesInfo =
                getParameter(
                        request,
                        "upgradesInfo",
                        "upgrades_info"
                );

        mapEmbed = sanitizeMapEmbed(
                mapEmbed,
                (citiesCovered != null && !citiesCovered.trim().isEmpty()) ? citiesCovered : statesCovered
        );

        String checkSql =
                "SELECT id FROM tour_details " +
                "WHERE tour_id = ?";

        Integer detailsId = null;

        try (PreparedStatement statement =
                     connection.prepareStatement(checkSql)) {

            statement.setInt(
                    1,
                    tourId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    detailsId =
                            resultSet.getInt("id");
                }
            }
        }

        // =========================================================
        // UPDATE EXISTING DETAILS
        // =========================================================

        if (detailsId != null) {

            String sql =
                    "UPDATE tour_details SET " +
                    "long_description = ?, " +
                    "highlights = ?, " +
                    "inclusions = ?, " +
                    "exclusions = ?, " +
                    "best_time = ?, " +
                    "map_embed = ?, " +
                    "duration_text = ?, " +
                    "states_covered = ?, " +
                    "cities_covered = ?, " +
                    "route = ?, " +
                    "preparation = ?, " +
                    "payment_terms = ?, " +
                    "upgrades_info = ? " +
                    "WHERE tour_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                statement.setString(1, longDescription);
                statement.setString(2, highlights);
                statement.setString(3, inclusions);
                statement.setString(4, exclusions);
                statement.setString(5, bestTime);
                statement.setString(6, mapEmbed);
                statement.setString(7, durationText);
                statement.setString(8, statesCovered);
                statement.setString(9, citiesCovered);
                statement.setString(10, route);
                statement.setString(11, preparation);
                statement.setString(12, paymentTerms);
                statement.setString(13, upgradesInfo);
                statement.setInt(14, tourId);

                statement.executeUpdate();
            }

        // =========================================================
        // INSERT NEW DETAILS
        // =========================================================

        } else {

            String sql =
                    "INSERT INTO tour_details (" +
                    "tour_id, long_description, highlights, " +
                    "inclusions, exclusions, best_time, " +
                    "map_embed, duration_text, states_covered, " +
                    "cities_covered, route, preparation, " +
                    "payment_terms, upgrades_info" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                statement.setInt(1, tourId);
                statement.setString(2, longDescription);
                statement.setString(3, highlights);
                statement.setString(4, inclusions);
                statement.setString(5, exclusions);
                statement.setString(6, bestTime);
                statement.setString(7, mapEmbed);
                statement.setString(8, durationText);
                statement.setString(9, statesCovered);
                statement.setString(10, citiesCovered);
                statement.setString(11, route);
                statement.setString(12, preparation);
                statement.setString(13, paymentTerms);
                statement.setString(14, upgradesInfo);

                statement.executeUpdate();
            }
        }
    }


    // =============================================================
    // ADD ITINERARY
    // =============================================================

    private void addItinerary(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int tourId =
                requiredInt(
                        request.getParameter("tourId")
                );

        ensureTourExists(
                connection,
                tourId
        );

        String dayNumberValue =
                getParameter(
                        request,
                        "dayNumber",
                        "day_number"
                );

        if (dayNumberValue == null ||
                dayNumberValue.trim().isEmpty()) {

            throw new Exception(
                    "Day number is required."
            );
        }

        int dayNumber;

        try {

            dayNumber =
                    Integer.parseInt(
                            dayNumberValue.trim()
                    );

        } catch (NumberFormatException e) {

            throw new Exception(
                    "Invalid day number."
            );
        }

        if (dayNumber <= 0) {

            throw new Exception(
                    "Day number must be greater than zero."
            );
        }

        String dayTitle =
                clean(
                        getParameter(
                                request,
                                "dayTitle",
                                "day_title"
                        )
                );

        String dayDescription =
                clean(
                        getParameter(
                                request,
                                "dayDescription",
                                "day_description"
                        )
                );

        if (dayTitle == null) {

            throw new Exception(
                    "Day title is required."
            );
        }

        if (dayDescription == null) {

            throw new Exception(
                    "Day description is required."
            );
        }

        String sql =
                "INSERT INTO tour_itinerary " +
                "(tour_id, day_number, day_title, day_description) " +
                "VALUES (?, ?, ?, ?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, tourId);
            statement.setInt(2, dayNumber);
            statement.setString(3, dayTitle);
            statement.setString(4, dayDescription);

            statement.executeUpdate();
        }
    }


    // =============================================================
    // UPDATE ITINERARY
    // =============================================================

    private void updateItinerary(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int id =
                requiredInt(
                        getParameter(
                                request,
                                "itineraryId",
                                "id"
                        )
                );

        String dayNumberValue =
                getParameter(
                        request,
                        "dayNumber",
                        "day_number"
                );

        int dayNumber;

        try {

            dayNumber =
                    Integer.parseInt(
                            dayNumberValue
                    );

        } catch (Exception e) {

            throw new Exception(
                    "Invalid day number."
            );
        }

        if (dayNumber <= 0) {

            throw new Exception(
                    "Day number must be greater than zero."
            );
        }

        String dayTitle =
                clean(
                        getParameter(
                                request,
                                "dayTitle",
                                "day_title"
                        )
                );

        String dayDescription =
                clean(
                        getParameter(
                                request,
                                "dayDescription",
                                "day_description"
                        )
                );

        if (dayTitle == null) {

            throw new Exception(
                    "Day title is required."
            );
        }

        if (dayDescription == null) {

            throw new Exception(
                    "Day description is required."
            );
        }

        String sql =
                "UPDATE tour_itinerary SET " +
                "day_number = ?, " +
                "day_title = ?, " +
                "day_description = ? " +
                "WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, dayNumber);
            statement.setString(2, dayTitle);
            statement.setString(3, dayDescription);
            statement.setInt(4, id);

            int updated =
                    statement.executeUpdate();

            if (updated == 0) {

                throw new Exception(
                        "Itinerary day not found."
                );
            }
        }
    }


    // =============================================================
    // DELETE ITINERARY
    // =============================================================

    private void deleteItinerary(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int id =
                requiredInt(
                        getParameter(
                                request,
                                "itineraryId",
                                "id"
                        )
                );

        String sql =
                "DELETE FROM tour_itinerary " +
                "WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    id
            );

            int deleted =
                    statement.executeUpdate();

            if (deleted == 0) {

                throw new Exception(
                        "Itinerary day not found."
                );
            }
        }
    }


    // =============================================================
    // ADD HOTEL
    // =============================================================

    private void addHotel(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int tourId =
                requiredInt(
                        request.getParameter("tourId")
                );

        ensureTourExists(
                connection,
                tourId
        );

        String city =
                clean(
                        request.getParameter("city")
                );

        String hotelName =
                clean(
                        getParameter(
                                request,
                                "hotelName",
                                "hotel_name"
                        )
                );

        String checkIn =
                clean(
                        getParameter(
                                request,
                                "checkIn",
                                "check_in"
                        )
                );

        String checkOut =
                clean(
                        getParameter(
                                request,
                                "checkOut",
                                "check_out"
                        )
                );

        if (city == null) {

            throw new Exception(
                    "City is required."
            );
        }

        if (hotelName == null) {

            throw new Exception(
                    "Hotel name is required."
            );
        }

        String sql =
                "INSERT INTO tour_hotels " +
                "(tour_id, city, hotel_name, check_in, check_out) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, tourId);
            statement.setString(2, city);
            statement.setString(3, hotelName);

            setSqlDate(
                    statement,
                    4,
                    checkIn
            );

            setSqlDate(
                    statement,
                    5,
                    checkOut
            );

            statement.executeUpdate();
        }
    }


    // =============================================================
    // UPDATE HOTEL
    // =============================================================

    private void updateHotel(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int id =
                requiredInt(
                        getParameter(
                                request,
                                "hotelId",
                                "id"
                        )
                );

        String city =
                clean(
                        request.getParameter("city")
                );

        String hotelName =
                clean(
                        getParameter(
                                request,
                                "hotelName",
                                "hotel_name"
                        )
                );

        String checkIn =
                clean(
                        getParameter(
                                request,
                                "checkIn",
                                "check_in"
                        )
                );

        String checkOut =
                clean(
                        getParameter(
                                request,
                                "checkOut",
                                "check_out"
                        )
                );

        if (city == null) {

            throw new Exception(
                    "City is required."
            );
        }

        if (hotelName == null) {

            throw new Exception(
                    "Hotel name is required."
            );
        }

        String sql =
                "UPDATE tour_hotels SET " +
                "city = ?, " +
                "hotel_name = ?, " +
                "check_in = ?, " +
                "check_out = ? " +
                "WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, city);
            statement.setString(2, hotelName);

            setSqlDate(
                    statement,
                    3,
                    checkIn
            );

            setSqlDate(
                    statement,
                    4,
                    checkOut
            );

            statement.setInt(
                    5,
                    id
            );

            int updated =
                    statement.executeUpdate();

            if (updated == 0) {

                throw new Exception(
                        "Hotel not found."
                );
            }
        }
    }


    // =============================================================
    // DELETE HOTEL
    // =============================================================

    private void deleteHotel(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int id =
                requiredInt(
                        getParameter(
                                request,
                                "hotelId",
                                "id"
                        )
                );

        String sql =
                "DELETE FROM tour_hotels " +
                "WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    id
            );

            int deleted =
                    statement.executeUpdate();

            if (deleted == 0) {

                throw new Exception(
                        "Hotel not found."
                );
            }
        }
    }


    // =============================================================
    // UPLOAD IMAGE
    // =============================================================

    private void uploadImage(Connection connection, HttpServletRequest request) throws Exception {
        int tourId = requiredInt(request.getParameter("tourId"));
        ensureTourExists(connection, tourId);
        Part filePart = request.getPart("image");
        if (filePart == null || filePart.getSize() == 0 || filePart.getSize() > 5L * 1024 * 1024) {
            throw new Exception("Choose a JPEG or PNG photo up to 5 MB.");
        }
        byte[] imageData;
        try (java.io.InputStream input = filePart.getInputStream()) { imageData = input.readAllBytes(); }
        String mimeType;
        try { mimeType = HolidayImageServlet.validateImage(imageData); }
        catch (IllegalArgumentException e) { throw new Exception(e.getMessage()); }
        String originalName = filePart.getSubmittedFileName();
        originalName = originalName == null ? "destination-photo" : originalName.replace((char) 92, '/');
        originalName = originalName.substring(originalName.lastIndexOf('/') + 1);
        if (originalName.length() > 240) originalName = originalName.substring(originalName.length() - 240);
        boolean isCover = "true".equalsIgnoreCase(getParameter(request, "isCover", "is_cover"));
        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);
            if (isCover) {
                try (PreparedStatement reset = connection.prepareStatement(
                        "UPDATE tour_images SET is_cover = FALSE WHERE tour_id = ?")) {
                    reset.setInt(1, tourId); reset.executeUpdate();
                }
            }
            try (PreparedStatement insert = connection.prepareStatement(
                    "INSERT INTO tour_images (tour_id,image_data,mime_type,original_name,is_cover) VALUES (?,?,?,?,?)")) {
                insert.setInt(1, tourId); insert.setBytes(2, imageData); insert.setString(3, mimeType);
                insert.setString(4, originalName); insert.setBoolean(5, isCover); insert.executeUpdate();
            }
            connection.commit();
        } catch (Exception e) {
            connection.rollback(); throw e;
        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }


    // =============================================================
    // DELETE IMAGE
    // =============================================================

    private void deleteImage(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int id =
                requiredInt(
                        getParameter(
                                request,
                                "imageId",
                                "id"
                        )
                );

        String sql =
                "DELETE FROM tour_images " +
                "WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    id
            );

            int deleted =
                    statement.executeUpdate();

            if (deleted == 0) {

                throw new Exception(
                        "Image not found."
                );
            }
        }
    }


    // =============================================================
    // SET COVER IMAGE
    // =============================================================

    private void setCoverImage(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int imageId =
                requiredInt(
                        getParameter(
                                request,
                                "imageId",
                                "id"
                        )
                );

        int tourId =
                requiredInt(
                        request.getParameter("tourId")
                );

        connection.setAutoCommit(false);

        try {

            // =====================================================
            // REMOVE COVER FROM ALL IMAGES
            // =====================================================

            String resetSql =
                    "UPDATE tour_images " +
                    "SET is_cover = FALSE " +
                    "WHERE tour_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(resetSql)) {

                statement.setInt(
                        1,
                        tourId
                );

                statement.executeUpdate();
            }

            // =====================================================
            // SET SELECTED IMAGE AS COVER
            // =====================================================

            String setSql =
                    "UPDATE tour_images " +
                    "SET is_cover = TRUE " +
                    "WHERE id = ? AND tour_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(setSql)) {

                statement.setInt(
                        1,
                        imageId
                );

                statement.setInt(
                        2,
                        tourId
                );

                int updated =
                        statement.executeUpdate();

                if (updated == 0) {

                    throw new Exception(
                            "Selected image does not belong to this tour."
                    );
                }
            }

            connection.commit();

        } catch (Exception e) {

            connection.rollback();

            throw e;

        } finally {

            connection.setAutoCommit(true);
        }
    }


    // =============================================================
    // DELETE ENTIRE TOUR
    // =============================================================

    private void deleteTour(
            Connection connection,
            HttpServletRequest request)
            throws Exception {

        int tourId =
                requiredInt(
                        request.getParameter("tourId")
                );

        connection.setAutoCommit(false);

        try {

            // =====================================================
            // DELETE TOUR DETAILS
            // =====================================================

            String detailsSql =
                    "DELETE FROM tour_details " +
                    "WHERE tour_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(detailsSql)) {

                statement.setInt(
                        1,
                        tourId
                );

                statement.executeUpdate();
            }

            // =====================================================
            // DELETE ITINERARY
            // =====================================================

            String itinerarySql =
                    "DELETE FROM tour_itinerary " +
                    "WHERE tour_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(itinerarySql)) {

                statement.setInt(
                        1,
                        tourId
                );

                statement.executeUpdate();
            }

            // =====================================================
            // DELETE HOTELS
            // =====================================================

            String hotelsSql =
                    "DELETE FROM tour_hotels " +
                    "WHERE tour_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(hotelsSql)) {

                statement.setInt(
                        1,
                        tourId
                );

                statement.executeUpdate();
            }

            // =====================================================
            // DELETE IMAGES
            // =====================================================

            String imagesSql =
                    "DELETE FROM tour_images " +
                    "WHERE tour_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(imagesSql)) {

                statement.setInt(
                        1,
                        tourId
                );

                statement.executeUpdate();
            }

            // =====================================================
            // DELETE MAIN TOUR
            // =====================================================

            String tourSql =
                    "DELETE FROM tours " +
                    "WHERE id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(tourSql)) {

                statement.setInt(
                        1,
                        tourId
                );

                int deleted =
                        statement.executeUpdate();

                if (deleted == 0) {

                    throw new Exception(
                            "Tour package not found."
                    );
                }
            }

            connection.commit();

        } catch (Exception e) {

            connection.rollback();

            throw e;

        } finally {

            connection.setAutoCommit(true);
        }
    }


    // =============================================================
    // LOAD ALL TOURS
    // =============================================================

    private List<Map<String, Object>> loadTours(
            Connection connection)
            throws Exception {

        List<Map<String, Object>> tours =
                new ArrayList<>();

        String sql =
                "SELECT id, name, category, departure_city, " +
                "duration, price, status, short_description, created_at, updated_at " +
                "FROM tours " +
                "ORDER BY id DESC";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                tours.add(
                        createTourMap(resultSet)
                );
            }
        }

        return tours;
    }


    // =============================================================
    // LOAD SINGLE TOUR
    // =============================================================

    private Map<String, Object> loadTour(
            Connection connection,
            int tourId)
            throws Exception {

        String sql =
                "SELECT id, name, category, departure_city, " +
                "duration, price, status, short_description, created_at, updated_at " +
                "FROM tours " +
                "WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    tourId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (!resultSet.next()) {

                    return null;
                }

                return createTourMap(
                        resultSet
                );
            }
        }
    }


    // =============================================================
    // TOUR MAP
    // =============================================================

    private Map<String, Object> createTourMap(
            ResultSet resultSet)
            throws Exception {

        Map<String, Object> tour =
                new LinkedHashMap<>();

        tour.put(
                "id",
                resultSet.getInt("id")
        );

        tour.put(
                "name",
                resultSet.getString("name")
        );

        tour.put(
                "category",
                resultSet.getString("category")
        );

        tour.put(
                "departure_city",
                resultSet.getString("departure_city")
        );

        tour.put(
                "duration",
                resultSet.getInt("duration")
        );

        tour.put(
                "price",
                resultSet.getBigDecimal("price")
        );

        tour.put(
                "status",
                resultSet.getString("status")
        );

        tour.put(
                "created_at",
                resultSet.getTimestamp("created_at")
        );

        tour.put(
                "updated_at",
                resultSet.getTimestamp("updated_at")
        );

        tour.put("short_description", resultSet.getString("short_description"));
        return tour;
    }


    // =============================================================
    // LOAD TOUR DETAILS
    // =============================================================

    private Map<String, Object> loadTourDetails(
            Connection connection,
            int tourId)
            throws Exception {

        String sql =
                "SELECT id, tour_id, long_description, " +
                "highlights, inclusions, exclusions, best_time, " +
                "map_embed, duration_text, states_covered, " +
                "cities_covered, route, preparation, " +
                "payment_terms, upgrades_info, created_at, " +
                "updated_at " +
                "FROM tour_details " +
                "WHERE tour_id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    tourId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (!resultSet.next()) {

                    return null;
                }

                Map<String, Object> details =
                        new LinkedHashMap<>();

                String[] columns = {

                        "id",
                        "tour_id",
                        "long_description",
                        "highlights",
                        "inclusions",
                        "exclusions",
                        "best_time",
                        "map_embed",
                        "duration_text",
                        "states_covered",
                        "cities_covered",
                        "route",
                        "preparation",
                        "payment_terms",
                        "upgrades_info",
                        "created_at",
                        "updated_at"
                };

                for (String column : columns) {

                    if (column.endsWith("_at")) {

                        details.put(
                                column,
                                resultSet.getTimestamp(column)
                        );

                    } else if (
                            column.equals("id")
                                    ||
                            column.equals("tour_id")
                    ) {

                        details.put(
                                column,
                                resultSet.getInt(column)
                        );

                    } else {

                        details.put(
                                column,
                                resultSet.getString(column)
                        );
                    }
                }

                return details;
            }
        }
    }


    // =============================================================
    // LOAD ITINERARY
    // =============================================================

    private List<Map<String, Object>> loadItinerary(
            Connection connection,
            int tourId)
            throws Exception {

        List<Map<String, Object>> itinerary =
                new ArrayList<>();

        String sql =
                "SELECT id, tour_id, day_number, " +
                "day_title, day_description " +
                "FROM tour_itinerary " +
                "WHERE tour_id = ? " +
                "ORDER BY day_number ASC, id ASC";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    tourId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    Map<String, Object> day =
                            new LinkedHashMap<>();

                    day.put(
                            "id",
                            resultSet.getInt("id")
                    );

                    day.put(
                            "tour_id",
                            resultSet.getInt("tour_id")
                    );

                    day.put(
                            "day_number",
                            resultSet.getInt("day_number")
                    );

                    day.put(
                            "day_title",
                            resultSet.getString("day_title")
                    );

                    day.put(
                            "day_description",
                            resultSet.getString(
                                    "day_description"
                            )
                    );

                    itinerary.add(day);
                }
            }
        }

        return itinerary;
    }


    // =============================================================
    // LOAD HOTELS
    // =============================================================

    private List<Map<String, Object>> loadHotels(
            Connection connection,
            int tourId)
            throws Exception {

        List<Map<String, Object>> hotels =
                new ArrayList<>();

        String sql =
                "SELECT id, tour_id, city, hotel_name, " +
                "check_in, check_out " +
                "FROM tour_hotels " +
                "WHERE tour_id = ? " +
                "ORDER BY check_in ASC, id ASC";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    tourId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    Map<String, Object> hotel =
                            new LinkedHashMap<>();

                    hotel.put(
                            "id",
                            resultSet.getInt("id")
                    );

                    hotel.put(
                            "tour_id",
                            resultSet.getInt("tour_id")
                    );

                    hotel.put(
                            "city",
                            resultSet.getString("city")
                    );

                    hotel.put(
                            "hotel_name",
                            resultSet.getString("hotel_name")
                    );

                    hotel.put(
                            "check_in",
                            resultSet.getDate("check_in")
                    );

                    hotel.put(
                            "check_out",
                            resultSet.getDate("check_out")
                    );

                    hotels.add(hotel);
                }
            }
        }

        return hotels;
    }


    // =============================================================
    // LOAD IMAGES
    // =============================================================

    private List<Map<String, Object>> loadImages(
            Connection connection,
            int tourId)
            throws Exception {

        List<Map<String, Object>> images =
                new ArrayList<>();

        String sql =
                "SELECT id, tour_id, mime_type, " +
                "original_name, is_cover, created_at " +
                "FROM tour_images " +
                "WHERE tour_id = ? " +
                "ORDER BY is_cover DESC, id ASC";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    tourId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    Map<String, Object> image =
                            new LinkedHashMap<>();

                    image.put(
                            "id",
                            resultSet.getInt("id")
                    );

                    image.put(
                            "tour_id",
                            resultSet.getInt("tour_id")
                    );

                    image.put(
                            "mime_type",
                            resultSet.getString("mime_type")
                    );

                    image.put(
                            "original_name",
                            resultSet.getString(
                                    "original_name"
                            )
                    );

                    image.put(
                            "is_cover",
                            resultSet.getBoolean(
                                    "is_cover"
                            )
                    );

                    image.put(
                            "created_at",
                            resultSet.getTimestamp(
                                    "created_at"
                            )
                    );

                    images.add(image);
                }
            }
        }

        return images;
    }


    // =============================================================
    // ENSURE TOUR EXISTS
    // =============================================================

    private void ensureTourExists(
            Connection connection,
            int tourId)
            throws Exception {

        String sql =
                "SELECT id FROM tours WHERE id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    tourId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (!resultSet.next()) {

                    throw new Exception(
                            "Tour package not found."
                    );
                }
            }
        }
    }


    // =============================================================
    // UTILITY: GET PARAMETER WITH FALLBACK
    // =============================================================

    private String getParameter(
            HttpServletRequest request,
            String primary,
            String fallback) {

        String value =
                request.getParameter(primary);

        if (value == null) {

            value =
                    request.getParameter(fallback);
        }

        return value;
    }


    // =============================================================
    // UTILITY: CLEAN STRING
    // =============================================================

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        if (value.isEmpty()) {
            return null;
        }

        return value;
    }


    // =============================================================
    // UTILITY: SET SQL DATE
    // =============================================================

    private void setSqlDate(
            PreparedStatement statement,
            int parameterIndex,
            String value)
            throws Exception {

        if (value == null ||
                value.trim().isEmpty()) {

            statement.setNull(
                    parameterIndex,
                    Types.DATE
            );

        } else {

            try {

                statement.setDate(
                        parameterIndex,
                        java.sql.Date.valueOf(
                                value.trim()
                        )
                );

            } catch (IllegalArgumentException e) {

                throw new Exception(
                        "Invalid date. Please use YYYY-MM-DD format."
                );
            }
        }
    }


    // =============================================================
    // UTILITY: PARSE INTEGER
    // =============================================================

    private Integer parseInteger(
            String value) {

        if (value == null ||
                value.trim().isEmpty()) {

            return null;
        }

        try {

            return Integer.parseInt(
                    value.trim()
            );

        } catch (NumberFormatException e) {

            return null;
        }
    }


    // =============================================================
    // UTILITY: REQUIRED INTEGER
    // =============================================================

    private int requiredInt(
            String value)
            throws Exception {

        if (value == null ||
                value.trim().isEmpty()) {

            throw new Exception(
                    "Required numeric value is missing."
            );
        }

        try {

            return Integer.parseInt(
                    value.trim()
            );

        } catch (NumberFormatException e) {

            throw new Exception(
                    "Invalid numeric value."
            );
        }
    }


    // =============================================================
    // UTILITY: ERROR MESSAGE
    // =============================================================

    private String getSafeErrorMessage(
            Exception e) {

        String message = e.getMessage();

        if (message == null ||
                message.trim().isEmpty()) {

            return "An unexpected error occurred.";
        }

        return message;
    }


    // =============================================================
    // FLASH MESSAGE
    // =============================================================

    private void setMessage(
            HttpServletRequest request,
            String message) {

        request.getSession()
                .setAttribute(
                        "adminMessage",
                        message
                );
    }

    private static String sanitizeMapEmbed(String input, String locationFallback) {
        if (input == null || input.trim().isEmpty()) {
            if (locationFallback != null && !locationFallback.trim().isEmpty()) {
                try {
                    return "https://maps.google.com/maps?q=" + java.net.URLEncoder.encode(locationFallback.trim() + ",India", java.nio.charset.StandardCharsets.UTF_8) + "&t=&z=11&ie=UTF8&iwloc=&output=embed";
                } catch (Exception ignored) {}
            }
            return null;
        }
        String clean = input.trim();
        if (clean.contains("<iframe")) {
            int srcIdx = clean.indexOf("src=\"");
            if (srcIdx != -1) {
                int endIdx = clean.indexOf("\"", srcIdx + 5);
                if (endIdx != -1) {
                    clean = clean.substring(srcIdx + 5, endIdx);
                }
            }
        }
        return clean;
    }
}
