<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>About Us | TravelTourism</title>
    <meta name="description" content="Learn about TravelTourism. We curate thoughtfully paced, authentic journeys across India connecting travellers with historic places, diverse cultures, and memorable stays.">

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about-premium.css?v=3">
</head>
<body>

    <!-- COMMON SITE HEADER -->
    <%@ include file="common/header.jsp" %>

    <main class="about-premium">

        <!-- =========================
             01: EDITORIAL HERO (NO IMAGES)
             ========================= -->
        <section class="about-hero">
            <div class="about-hero-copy">
                <p class="about-kicker">ABOUT TRAVELTOUSIM · EST. 2026 · MUMBAI, INDIA</p>
                <h1>
                    Thoughtfully paced.<br>
                    <em>Deeply rooted in India.</em>
                </h1>
                <p class="about-hero-lead">
                    TravelTourism was founded on a simple belief: the best travel experiences aren't about rushing between
                    crowded monuments on a rigid schedule. They are about having the time to breathe, connect with living traditions,
                    savor local cuisine, and return home with stories you'll remember for decades.
                </p>
                <div class="about-hero-actions">
                    <a href="${pageContext.request.contextPath}/destinations" class="about-hero-btn">
                        <span>Explore Our Journeys</span>
                        <span aria-hidden="true">→</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/contact" class="about-hero-link">
                        <span>Speak with a Travel Specialist</span>
                        <span aria-hidden="true">→</span>
                    </a>
                </div>
            </div>

            <div class="about-hero-aside">
                <div class="about-monogram" aria-hidden="true">TT</div>
                <blockquote>
                    "Travel is at its most rewarding when you slow down enough to listen, savor, and truly understand a place."
                </blockquote>
                <div class="quote-author">
                    <strong>The TravelTourism Team</strong>
                    <span>Curating Journeys Across India</span>
                </div>
            </div>
        </section>

        <!-- =========================
             02: CREDIBILITY STRIP
             ========================= -->
        <div class="about-trust-strip" aria-label="Key highlights">
            <div class="trust-item">
                <div class="trust-item-icon" aria-hidden="true">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"></polygon>
                        <line x1="8" y1="2" x2="8" y2="18"></line>
                        <line x1="16" y1="6" x2="16" y2="22"></line>
                    </svg>
                </div>
                <div class="trust-item-text">
                    <strong>6 Curated Regions</strong>
                    <span>Handpicked regional routes</span>
                </div>
            </div>

            <div class="trust-item">
                <div class="trust-item-icon" aria-hidden="true">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                </div>
                <div class="trust-item-text">
                    <strong>Paced Itineraries</strong>
                    <span>Never hurried or exhausted</span>
                </div>
            </div>

            <div class="trust-item">
                <div class="trust-item-icon" aria-hidden="true">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                    </svg>
                </div>
                <div class="trust-item-text">
                    <strong>Custom Flexibility</strong>
                    <span>Tailored to your preferences</span>
                </div>
            </div>

            <div class="trust-item">
                <div class="trust-item-icon" aria-hidden="true">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                    </svg>
                </div>
                <div class="trust-item-text">
                    <strong>Personal Support</strong>
                    <span>Direct human guidance 24/7</span>
                </div>
            </div>
        </div>

        <!-- =========================
             03: OUR STORY & PHILOSOPHY (NO IMAGES)
             ========================= -->
        <section class="about-story-section">
            <div class="story-manifesto-card">
                <div class="manifesto-badge">OUR MANIFESTO</div>
                <h2>Why we choose depth over rush.</h2>
                <p>
                    Too often, touring India becomes an endurance test: waking up at dawn, spending six hours in transit,
                    snapping photographs at a monument, and driving to the next hotel. By the end of the trip, you need
                    another vacation just to recover.
                </p>
                <p>
                    We build every itinerary differently. When you visit Rajasthan, we leave open afternoons to wander the
                    cobbled streets of Udaipur. When you travel to Kerala, we ensure you spend quiet hours on a traditional
                    backwater boat instead of rushing through tourist terminals.
                </p>
                <div class="manifesto-quote">
                    "We measure the success of a trip not by how many destinations you checked off, but by the memories that remain vivid years later."
                </div>
            </div>

            <div class="story-narrative">
                <p class="about-kicker">OUR CORE PRINCIPLES</p>
                <h2>The three pillars behind every trip we design.</h2>

                <div class="story-pillars">
                    <div class="pillar-row">
                        <div class="pillar-number">01</div>
                        <div class="pillar-copy">
                            <strong>Restful &amp; Realistic Pacing</strong>
                            <p>We deliberately plan multi-night stays in each region so you unpack once, settle in, and experience the place at your own rhythm.</p>
                        </div>
                    </div>

                    <div class="pillar-row">
                        <div class="pillar-number">02</div>
                        <div class="pillar-copy">
                            <strong>Character Over Chain Hotels</strong>
                            <p>We partner with heritage havelis, plantation bungalows, and independent boutique retreats chosen for their warmth, history, and distinct sense of place.</p>
                        </div>
                    </div>

                    <div class="pillar-row">
                        <div class="pillar-number">03</div>
                        <div class="pillar-copy">
                            <strong>Local Navigators with Deep Knowledge</strong>
                            <p>Our guides are resident naturalists, historians, and storytellers who bring folklore, architectural nuances, and local culinary traditions alive.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- =========================
             04: OUR TRAVEL COLLECTION
             ========================= -->
        <section class="about-collection-section">
            <div class="section-head-center">
                <p class="about-kicker">EXPLORE OUR OFFERINGS</p>
                <h2>Three ways to travel with us.</h2>
                <p>Whether you're embarking on an iconic regional expedition or celebrating a milestone anniversary, explore our curated travel options.</p>
            </div>

            <div class="about-cards-grid">
                <!-- Card 1 -->
                <a href="${pageContext.request.contextPath}/destinations" class="about-card">
                    <span class="about-card-badge">POPULAR TOURS</span>
                    <h3>The Destination Collection</h3>
                    <p>Carefully planned itineraries across Goa, Rajasthan, Kerala, Kashmir, Himachal Pradesh, and Maharashtra with complete details, hotels, and day plans.</p>
                    <span class="about-card-link">
                        <span>Browse Destination Tours</span>
                        <span aria-hidden="true">→</span>
                    </span>
                </a>

                <!-- Card 2 -->
                <a href="${pageContext.request.contextPath}/customize" class="about-card">
                    <span class="about-card-badge">OCCASIONS</span>
                    <h3>Customized Holidays</h3>
                    <p>Dedicated occasion packages designed for honeymoons, milestone birthdays, family reunions, and peaceful getaways with customized touches.</p>
                    <span class="about-card-link">
                        <span>View Occasion Packages</span>
                        <span aria-hidden="true">→</span>
                    </span>
                </a>

                <!-- Card 3 -->
                <a href="${pageContext.request.contextPath}/experiences" class="about-card">
                    <span class="about-card-badge">SIGNATURE</span>
                    <h3>Curated Experiences</h3>
                    <p>Wildlife tracking in protected reserves, private houseboat sailing on Vembanad Lake, heritage walking tours, and authentic regional culinary trails.</p>
                    <span class="about-card-link">
                        <span>Explore Experiences</span>
                        <span aria-hidden="true">→</span>
                    </span>
                </a>
            </div>
        </section>

        <!-- =========================
             05: CORE COMMITMENTS
             ========================= -->
        <section class="about-standards-section">
            <div class="standards-header">
                <div>
                    <p class="about-kicker">OUR COMMITMENT</p>
                    <h2>The TravelTourism Standard</h2>
                </div>
                <p>Every booking is supported by honest policies and dedicated human support from your first enquiry until you return home.</p>
            </div>

            <div class="standards-grid">
                <div class="standard-card">
                    <div class="standard-icon" aria-hidden="true">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="12" y1="1" x2="12" y2="23"></line>
                            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                        </svg>
                    </div>
                    <h4>Upfront, Transparent Pricing</h4>
                    <p>Clear package costs with no hidden transfer fees, surprise surcharges, or forced commercial shopping stops.</p>
                </div>

                <div class="standard-card">
                    <div class="standard-icon" aria-hidden="true">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                    </div>
                    <h4>Personally Verified Stays</h4>
                    <p>Every accommodation is vetted for cleanliness, security, hospitality, and comfortable beds.</p>
                </div>

                <div class="standard-card">
                    <div class="standard-icon" aria-hidden="true">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                        </svg>
                    </div>
                    <h4>Dedicated Human Care</h4>
                    <p>Direct contact with our team throughout your trip planning and while traveling, so you never feel stranded.</p>
                </div>

                <div class="standard-card">
                    <div class="standard-icon" aria-hidden="true">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"></path>
                        </svg>
                    </div>
                    <h4>Support for Local Communities</h4>
                    <p>We work directly with regional drivers, traditional boatmen, and local guides to keep your travel spending in the local economy.</p>
                </div>
            </div>
        </section>

        <!-- =========================
             06: INVITATION / CTA
             ========================= -->
        <section class="about-cta-section">
            <div class="about-cta-content">
                <p class="about-kicker">BEGIN PLANNING</p>
                <h2>Ready to explore India your way?</h2>
                <p>
                    Browse our destination itineraries or talk directly with our travel specialists to create a trip tailored to your exact dates, preferences, and group size.
                </p>
                <div class="about-cta-buttons">
                    <a href="${pageContext.request.contextPath}/destinations" class="cta-primary-btn">
                        <span>Browse Destinations</span>
                        <span aria-hidden="true">→</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/contact" class="cta-secondary-btn">
                        <span>Talk to a Travel Specialist</span>
                    </a>
                </div>
            </div>
        </section>

    </main>

    <!-- COMMON SITE FOOTER -->
    <%@ include file="common/footer.jsp" %>

</body>
</html>