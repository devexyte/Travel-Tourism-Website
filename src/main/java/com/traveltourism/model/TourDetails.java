package com.traveltourism.model;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class TourDetails {

    private int tourId;
    private String longDescription;
    private String itinerary;
    private String highlights;
    private String inclusions;
    private String exclusions;
    private String bestTime;
    private String mapEmbed;

    private String durationText;
    private String statesCovered;
    private String citiesCovered;
    private String route;
    private String preparation;
    private String paymentTerms;
    private String upgradesInfo;

    public TourDetails(int tourId, String longDescription, String itinerary, String highlights,
                       String inclusions, String exclusions, String bestTime, String mapEmbed,
                       String preparation, String paymentTerms, String upgradesInfo) {
        this(tourId, longDescription, itinerary, highlights, inclusions, exclusions, bestTime,
             mapEmbed, null, null, null, null, preparation, paymentTerms, upgradesInfo);
    }

    public TourDetails(int tourId, String longDescription, String itinerary, String highlights,
                       String inclusions, String exclusions, String bestTime, String mapEmbed,
                       String durationText, String statesCovered, String citiesCovered, String route,
                       String preparation, String paymentTerms, String upgradesInfo) {
        this.tourId = tourId;
        this.longDescription = longDescription;
        this.itinerary = itinerary;
        this.highlights = highlights;
        this.inclusions = inclusions;
        this.exclusions = exclusions;
        this.bestTime = bestTime;
        this.mapEmbed = mapEmbed;
        this.durationText = durationText;
        this.statesCovered = statesCovered;
        this.citiesCovered = citiesCovered;
        this.route = route;
        this.preparation = preparation;
        this.paymentTerms = paymentTerms;
        this.upgradesInfo = upgradesInfo;
    }

    public int getTourId() { return tourId; }
    public String getLongDescription() { return longDescription; }
    public String getItinerary() { return itinerary; }
    public String getHighlights() { return highlights; }
    public String getInclusions() { return inclusions; }
    public String getExclusions() { return exclusions; }
    public String getBestTime() { return bestTime; }

    public String getMapEmbed() {
        if (mapEmbed == null || mapEmbed.trim().isEmpty()) {
            String q = (citiesCovered != null && !citiesCovered.trim().isEmpty()) ? citiesCovered : statesCovered;
            if (q == null || q.trim().isEmpty()) q = "India";
            try {
                return "https://maps.google.com/maps?q=" + URLEncoder.encode(q + ",India", StandardCharsets.UTF_8) + "&t=&z=11&ie=UTF8&iwloc=&output=embed";
            } catch (Exception e) {
                return "https://maps.google.com/maps?q=India&t=&z=5&ie=UTF8&iwloc=&output=embed";
            }
        }
        String clean = mapEmbed.trim();
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

    public String getDurationText() { return durationText; }
    public String getStatesCovered() { return statesCovered; }
    public String getCitiesCovered() { return citiesCovered; }
    public String getRoute() { return route; }
    public String getPreparation() { return preparation; }
    public String getPaymentTerms() { return paymentTerms; }
    public String getUpgradesInfo() { return upgradesInfo; }
}
