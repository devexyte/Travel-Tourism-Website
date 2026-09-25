<%@ page contentType="text/html;charset=UTF-8" import="java.util.Map" %>
<%!
private String esc(Object value) {
    if (value == null) return "";
    return value.toString()
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}
%>
<%
    Map<String, String> content = (Map<String, String>) request.getAttribute("content");
    String context = request.getContextPath();
    String csrf = (String) session.getAttribute("homepageCsrf");

    String[][] slots = {
        {"hero", "Homepage Hero Banner", "Wide landscape hero image · ideally 1600 × 900 px"},
        {"goa", "Goa Destination Card", "Coastal landscape · ideally 900 × 600 px"},
        {"kerala", "Kerala Destination Card", "Backwaters & greenery · ideally 900 × 600 px"},
        {"rajasthan", "Rajasthan Destination Card", "Heritage & palaces · ideally 900 × 600 px"},
        {"kashmir", "Kashmir Destination Card", "Valleys & mountains · ideally 900 × 600 px"},
        {"himachal", "Himachal Destination Card", "Snow & pines · ideally 900 × 600 px"},
        {"maharashtra", "Maharashtra Destination Card", "Forts & coast · ideally 900 × 600 px"},
        {"holiday", "Occasion Holidays Showcase", "Editorial feature · ideally 1000 × 1200 px"}
    };
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Homepage Studio | TravelTourism Admin</title>
    <link rel="stylesheet" href="<%= context %>/css/admin-workspace.css?v=6">
</head>
<body class="holiday-admin homepage-admin">

    <% request.setAttribute("adminSection", "homepage"); %>
    <%@ include file="/WEB-INF/admin/navigation.jspf" %>

    <!-- PAGE HERO BANNER -->
    <section class="admin-intro">
        <div>
            <span class="eyebrow">HOMEPAGE PRESENTATION</span>
            <h1>Homepage Studio</h1>
            <p>Keep your primary showcase current, polished, and directly connected with the journeys you offer.</p>
        </div>
        <div class="admin-metrics">
            <div>
                <strong>8</strong>
                <span>Photo Slots</span>
            </div>
            <div>
                <strong>3</strong>
                <span>Stories</span>
            </div>
        </div>
    </section>

    <main class="homepage-admin-layout">

        <% if (request.getAttribute("notice") != null) { %>
            <div class="admin-notice" role="status">
                <%= esc(request.getAttribute("notice")) %>
            </div>
        <% } %>

        <!-- ================= SECTION 1: EDITORIAL COPY ================= -->
        <section class="card homepage-copy-card">
            <div class="editor-title">
                <div>
                    <span class="eyebrow">WORDS &amp; MESSAGING</span>
                    <h2>Featured Homepage Wording</h2>
                </div>
                <a class="button" href="<%= context %>/index.jsp" target="_blank" rel="noopener">
                    <span>Preview Public Homepage</span>
                    <span aria-hidden="true">&#8599;</span>
                </a>
            </div>

            <form method="post" action="<%= context %>/admin/homepage">
                <input type="hidden" name="csrf" value="<%= esc(csrf) %>">

                <!-- 01: HERO SECTION -->
                <div class="homepage-form-section">
                    <div class="section-heading">
                        <span>01</span>
                        <div>
                            <h3>Hero Introduction</h3>
                            <p>The headline and welcome text guests see immediately upon arrival.</p>
                        </div>
                    </div>
                    <div class="form-grid">
                        <label>
                            Kicker Label
                            <input name="hero_label" maxlength="120" value="<%= esc(content != null ? content.get("hero_label") : "") %>" required placeholder="e.g. HANDCRAFTED ITINERARIES">
                        </label>
                        <label>
                            Main Heading
                            <input name="hero_title" maxlength="120" value="<%= esc(content != null ? content.get("hero_title") : "") %>" required placeholder="e.g. Discover India">
                        </label>
                        <label class="full">
                            Accent Subheading
                            <input name="hero_accent" maxlength="120" value="<%= esc(content != null ? content.get("hero_accent") : "") %>" required placeholder="e.g. One Thoughtful Journey at a Time">
                        </label>
                        <label class="full">
                            Lead Paragraph
                            <textarea name="hero_description" maxlength="700" required rows="3" placeholder="Describe the TravelTourism philosophy..."><%= esc(content != null ? content.get("hero_description") : "") %></textarea>
                        </label>
                    </div>
                </div>

                <!-- 02: POPULAR DESTINATIONS -->
                <div class="homepage-form-section">
                    <div class="section-heading">
                        <span>02</span>
                        <div>
                            <h3>Popular Destinations Section</h3>
                            <p>Introduction for the curated regional destination collection.</p>
                        </div>
                    </div>
                    <div class="form-grid">
                        <label>
                            Section Tagline
                            <input name="destination_label" maxlength="120" value="<%= esc(content != null ? content.get("destination_label") : "") %>" required placeholder="e.g. ICONIC DESTINATIONS">
                        </label>
                        <label>
                            Main Heading
                            <input name="destination_title" maxlength="120" value="<%= esc(content != null ? content.get("destination_title") : "") %>" required placeholder="e.g. Places That Leave a Lasting Impression">
                        </label>
                        <label class="full">
                            Section Description
                            <textarea name="destination_description" maxlength="700" required rows="3"><%= esc(content != null ? content.get("destination_description") : "") %></textarea>
                        </label>
                    </div>
                </div>

                <!-- 03: CUSTOMIZED HOLIDAYS -->
                <div class="homepage-form-section">
                    <div class="section-heading">
                        <span>03</span>
                        <div>
                            <h3>Customized Holidays Showcase</h3>
                            <p>Highlight occasion-based bespoke holidays on the homepage.</p>
                        </div>
                    </div>
                    <div class="form-grid">
                        <label>
                            Section Tagline
                            <input name="holiday_label" maxlength="120" value="<%= esc(content != null ? content.get("holiday_label") : "") %>" required placeholder="e.g. SPECIAL OCCASIONS">
                        </label>
                        <label>
                            Section Heading
                            <input name="holiday_title" maxlength="120" value="<%= esc(content != null ? content.get("holiday_title") : "") %>" required placeholder="e.g. Tailored to Life's Milestones">
                        </label>
                        <label class="full">
                            Description
                            <textarea name="holiday_description" maxlength="700" required rows="3"><%= esc(content != null ? content.get("holiday_description") : "") %></textarea>
                        </label>
                        <label>
                            Call-To-Action Button Text
                            <input name="holiday_button" maxlength="120" value="<%= esc(content != null ? content.get("holiday_button") : "") %>" required placeholder="e.g. Explore Occasion Packages">
                        </label>
                    </div>
                </div>

                <!-- STICKY ACTION BAR -->
                <div class="editor-save">
                    <p>Wording changes update the public homepage immediately upon saving.</p>
                    <button class="button primary" type="submit">Save Homepage Wording</button>
                </div>
            </form>
        </section>

        <!-- ================= SECTION 2: PHOTO STUDIO ================= -->
        <section class="card" id="photos">
            <div class="editor-title">
                <div>
                    <span class="eyebrow">VISUAL ASSETS</span>
                    <h2>Homepage Photo Gallery</h2>
                </div>
                <small style="color: var(--admin-muted); font-size: 12px; font-weight: 500;">
                    Supports JPEG, PNG or WebP · Up to 5 MB per photo
                </small>
            </div>

            <div class="homepage-photo-grid">
                <% for (String[] slot : slots) { %>
                    <article class="homepage-photo-card">
                        <img src="<%= context %>/homepage-image?slot=<%= slot[0] %>&amp;v=<%= System.currentTimeMillis() %>"
                             alt="<%= esc(slot[1]) %> preview"
                             loading="lazy">
                        <div class="homepage-photo-copy">
                            <div>
                                <h3><%= esc(slot[1]) %></h3>
                                <p><%= esc(slot[2]) %></p>
                            </div>
                            <div>
                                <form method="post" enctype="multipart/form-data" action="<%= context %>/admin/homepage-image">
                                    <input type="hidden" name="csrf" value="<%= esc(csrf) %>">
                                    <input type="hidden" name="slot" value="<%= slot[0] %>">
                                    <input type="file" name="photo" accept="image/jpeg,image/png,image/webp" required>
                                    <button class="button primary" type="submit">Upload / Replace Photo</button>
                                </form>
                                <form method="post" action="<%= context %>/admin/homepage-image" onsubmit="return confirm('Reset this slot to the default photo?');">
                                    <input type="hidden" name="csrf" value="<%= esc(csrf) %>">
                                    <input type="hidden" name="slot" value="<%= slot[0] %>">
                                    <input type="hidden" name="action" value="remove">
                                    <button class="button" type="submit">Remove / Reset Photo</button>
                                </form>
                            </div>
                        </div>
                    </article>
                <% } %>
            </div>
        </section>

    </main>

</body>
</html>