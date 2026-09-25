package com.traveltourism.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TourDataAccess {

    public static class TourPackageBundle {
        private final Tour tour;
        private final TourDetails details;
        private final List<TourImages> images;
        private final List<TourItinerary> itinerary;
        private final List<TourHotel> hotels;

        public TourPackageBundle(Tour tour, TourDetails details, List<TourImages> images,
                                 List<TourItinerary> itinerary, List<TourHotel> hotels) {
            this.tour = tour;
            this.details = details;
            this.images = images != null ? images : new ArrayList<>();
            this.itinerary = itinerary != null ? itinerary : new ArrayList<>();
            this.hotels = hotels != null ? hotels : new ArrayList<>();
        }

        public Tour getTour() { return tour; }
        public TourDetails getDetails() { return details; }
        public List<TourImages> getImages() { return images; }
        public List<TourItinerary> getItinerary() { return itinerary; }
        public List<TourHotel> getHotels() { return hotels; }
    }

    // =========================================================
    // 1. GET ALL TOURS
    // =========================================================

    public List<Tour> get_all_tours() {
        List<Tour> list = new ArrayList<>();
        String sql =
                "SELECT " +
                "t.id, " +
                "t.name, " +
                "t.price, " +
                "t.category, " +
                "t.departure_city, " +
                "t.duration, " +
                "t.short_description, " +
                "ti.id AS image_id " +
                "FROM tours t " +
                "LEFT JOIN tour_images ti " +
                "ON t.id = ti.tour_id " +
                "AND ti.is_cover = TRUE " +
                "WHERE t.status = 'active' " +
                "ORDER BY t.id ASC";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Tour t = new Tour(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("image_id"),
                        rs.getInt("price"),
                        rs.getString("category"),
                        rs.getString("departure_city"),
                        rs.getInt("duration"),
                        rs.getString("short_description")
                );
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================================================
    // 2. GET TOUR BUNDLE (OPTIMIZED SINGLE CONNECTION)
    // =========================================================

    public TourPackageBundle getTourPackageBundle(int id) {
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) return null;
            Tour tour = getTourById(con, id);
            if (tour == null) return null;
            TourDetails details = getTourDetailsById(con, id);
            List<TourImages> images = getTourImagesById(con, id);
            List<TourItinerary> itinerary = getItineraryByTourId(con, id);
            List<TourHotel> hotels = getHotelsByTourId(con, id);
            return new TourPackageBundle(tour, details, images, itinerary, hotels);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // =========================================================
    // 3. GET TOUR BY ID
    // =========================================================

    public Tour getTourById(int id) {
        try (Connection con = DBConnection.getConnection()) {
            return con != null ? getTourById(con, id) : null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Tour getTourById(Connection con, int id) {
        Tour tour = null;
        String sql =
                "SELECT " +
                "t.id, " +
                "t.name, " +
                "t.price, " +
                "t.category, " +
                "t.departure_city, " +
                "t.duration, " +
                "t.short_description, " +
                "ti.id AS image_id " +
                "FROM tours t " +
                "LEFT JOIN tour_images ti " +
                "ON t.id = ti.tour_id " +
                "AND ti.is_cover = TRUE " +
                "WHERE t.id = ? AND t.status = 'active'";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tour = new Tour(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("image_id"),
                            rs.getInt("price"),
                            rs.getString("category"),
                            rs.getString("departure_city"),
                            rs.getInt("duration"),
                            rs.getString("short_description")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tour;
    }

    // =========================================================
    // 4. GET TOUR DETAILS BY ID
    // =========================================================

    public TourDetails getTourDetailsById(int id) {
        try (Connection con = DBConnection.getConnection()) {
            return con != null ? getTourDetailsById(con, id) : null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public TourDetails getTourDetailsById(Connection con, int id) {
        TourDetails details = null;
        String sql = "SELECT * FROM tour_details WHERE tour_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    details = new TourDetails(
                            rs.getInt("tour_id"),
                            rs.getString("long_description"),
                            null,
                            rs.getString("highlights"),
                            rs.getString("inclusions"),
                            rs.getString("exclusions"),
                            rs.getString("best_time"),
                            rs.getString("map_embed"),
                            rs.getString("duration_text"),
                            rs.getString("states_covered"),
                            rs.getString("cities_covered"),
                            rs.getString("route"),
                            rs.getString("preparation"),
                            rs.getString("payment_terms"),
                            rs.getString("upgrades_info")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    // =========================================================
    // 5. GET TOUR IMAGES BY TOUR ID
    // =========================================================

    public List<TourImages> getTourImagesById(int id) {
        try (Connection con = DBConnection.getConnection()) {
            return con != null ? getTourImagesById(con, id) : new ArrayList<>();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<TourImages> getTourImagesById(Connection con, int id) {
        List<TourImages> images = new ArrayList<>();
        String sql =
                "SELECT id, tour_id, is_cover " +
                "FROM tour_images " +
                "WHERE tour_id = ? " +
                "ORDER BY is_cover DESC, id ASC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourImages img = new TourImages(
                            rs.getInt("id"),
                            rs.getInt("tour_id"),
                            null,
                            null,
                            rs.getBoolean("is_cover")
                    );
                    images.add(img);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

    // =========================================================
    // 6. GET DAY-WISE ITINERARY
    // =========================================================

    public List<TourItinerary> getItineraryByTourId(int id) {
        try (Connection con = DBConnection.getConnection()) {
            return con != null ? getItineraryByTourId(con, id) : new ArrayList<>();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<TourItinerary> getItineraryByTourId(Connection con, int id) {
        List<TourItinerary> list = new ArrayList<>();
        String sql =
                "SELECT * " +
                "FROM tour_itinerary " +
                "WHERE tour_id = ? " +
                "ORDER BY day_number ASC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourItinerary ti = new TourItinerary(
                            rs.getInt("day_number"),
                            rs.getString("day_title"),
                            rs.getString("day_description")
                    );
                    list.add(ti);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================================================
    // 7. GET HOTEL DETAILS
    // =========================================================

    public List<TourHotel> getHotelsByTourId(int id) {
        try (Connection con = DBConnection.getConnection()) {
            return con != null ? getHotelsByTourId(con, id) : new ArrayList<>();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<TourHotel> getHotelsByTourId(Connection con, int id) {
        List<TourHotel> list = new ArrayList<>();
        String sql = "SELECT * FROM tour_hotels WHERE tour_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourHotel th = new TourHotel(
                            rs.getString("city"),
                            rs.getString("hotel_name"),
                            rs.getString("check_in"),
                            rs.getString("check_out")
                    );
                    list.add(th);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}