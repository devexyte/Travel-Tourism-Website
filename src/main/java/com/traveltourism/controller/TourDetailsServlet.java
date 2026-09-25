package com.traveltourism.controller;

import java.io.IOException;
import com.traveltourism.model.Tour;
import com.traveltourism.model.TourDataAccess;
import com.traveltourism.model.TourDataAccess.TourPackageBundle;
import com.traveltourism.model.TourDetails;
import com.traveltourism.model.TourHotel;
import com.traveltourism.model.TourItinerary;
import com.traveltourism.model.TourImages;

import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/tour-details")
public class TourDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParameter = request.getParameter("id");
        int id;

        try {
            id = Integer.parseInt(idParameter);
        } catch (NumberFormatException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "A valid tour id is required.");
            return;
        }

        TourDataAccess dao = new TourDataAccess();
        TourPackageBundle bundle = dao.getTourPackageBundle(id);

        if (bundle == null || bundle.getTour() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tour not found.");
            return;
        }

        request.setAttribute("tour", bundle.getTour());
        request.setAttribute("details", bundle.getDetails());
        request.setAttribute("images", bundle.getImages());
        request.setAttribute("itinerary", bundle.getItinerary());
        request.setAttribute("hotels", bundle.getHotels());

        RequestDispatcher rd = request.getRequestDispatcher("/tour_details.jsp");
        rd.forward(request, response);
    }
}
