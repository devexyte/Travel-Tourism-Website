<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.net.URLEncoder,java.nio.charset.StandardCharsets" %>
<%!
private String esc(Object value) {
    return value == null ? "" : value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
}
%>
<%
List<Map<String,Object>> packages = (List<Map<String,Object>>) request.getAttribute("packages");
Map<String,Object> editor = (Map<String,Object>) request.getAttribute("editor");
if (editor == null) editor = new HashMap<>();
List<String> days = (List<String>) request.getAttribute("days");
if (days == null) days = new ArrayList<>();
boolean editing = Boolean.TRUE.equals(request.getAttribute("editing"));
String context = request.getContextPath();
long live = packages.stream().filter(p -> "1".equals(p.get("active")) && p.get("occasion") != null && !p.get("occasion").toString().isBlank()).count();
%>
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Customized Holidays | TravelTourism Admin</title>
<link rel="stylesheet" href="<%= context %>/css/admin-workspace.css?v=6">
<script defer src="<%= context %>/js/admin-holidays.js"></script>
</head><body class="holiday-admin">
<% request.setAttribute("adminSection", "holidays"); %><%@ include file="/WEB-INF/admin/navigation.jspf" %>
<div class="admin-intro"><div><span class="eyebrow">THE OCCASION COLLECTION</span><h1>Make every getaway personal.</h1><p>Curate the packages, prices and experiences your travellers can book.</p></div>
<div class="admin-metrics"><div><strong><%= packages.size() %></strong><span>Packages</span></div><div><strong><%= live %></strong><span>Published</span></div><div><strong><%= packages.size()-live %></strong><span>Hidden</span></div></div></div>
<div class="holiday-layout">
<aside class="holiday-catalog card"><div class="catalog-heading"><h2>Your collection</h2><a class="button primary" href="<%= context %>/admin/holidays">+ New</a></div>
<label for="holiday-search">Find a package</label><input id="holiday-search" type="search" placeholder="Name, occasion or departure city">
<p id="search-count" class="muted" aria-live="polite"><%= packages.size() %> packages</p>
<div id="holiday-list">
<% for (Map<String,Object> p : packages) { %>
<a class="holiday-item <%= Objects.equals(p.get("id"),editor.get("id")) ? "selected" : "" %>" href="<%= context %>/admin/holidays?id=<%= esc(URLEncoder.encode(p.get("id").toString(), StandardCharsets.UTF_8)) %>">
<span class="holiday-item-title"><%= esc(p.get("name")) %></span>
<span><%= p.get("occasion") == null || p.get("occasion").toString().isBlank() ? "Set an occasion" : esc(p.get("occasion")) %> · <%= esc(p.get("departure_city")) %></span>
<span><%= esc(p.get("duration")) %> days · ₹<%= esc(p.get("price")) %> <b class="pill"><%= p.get("occasion") == null || p.get("occasion").toString().isBlank() ? "Needs occasion" : ("1".equals(p.get("active")) ? "Published" : "Hidden") %></b></span>
</a><% } %>
</div><p id="no-results" hidden>No packages match your search.</p>
<% if (packages.isEmpty()) { %><p>Create your first occasion-based holiday to start your collection.</p><% } %>
</aside>
<main class="holiday-editor">
<div class="editor-title"><div><span class="eyebrow"><%= editing ? "PACKAGE EDITOR" : "NEW EXPERIENCE" %></span><h2><%= editing ? esc(editor.get("name")) : "Create a customized holiday" %></h2></div>
<% if (editing && "1".equals(editor.get("active")) && editor.get("occasion") != null && !editor.get("occasion").toString().isBlank()) { %><a class="button" target="_blank" rel="noopener" href="<%= context %>/holiday-details?id=<%= esc(URLEncoder.encode(editor.get("id").toString(), StandardCharsets.UTF_8)) %>">View details ↗</a><% } %></div>
<% if (request.getAttribute("notice") != null) { %><div class="admin-notice" role="status"><%= esc(request.getAttribute("notice")) %></div><% } %>
<% if (request.getAttribute("error") != null) { %><div class="admin-error" role="alert"><%= esc(request.getAttribute("error")) %></div><% } %>
<section class="card" id="cover-photo">
<div class="section-heading"><span>◈</span><div><h3>Main package image</h3><p>This cover photo appears with the package on the holiday listing and details page.</p></div></div>
<% if (editing) { %>
<div class="holiday-photo-editor">
<img id="holiday-photo-preview" src="<%= context %>/holiday-image?id=<%= esc(URLEncoder.encode(editor.get("id").toString(), StandardCharsets.UTF_8)) %>" alt="Current holiday cover" width="360" height="240">
<div><form method="post" enctype="multipart/form-data" action="<%= context %>/admin/holiday-image">
<input type="hidden" name="csrf" value="<%= esc(session.getAttribute("holidayCsrf")) %>">
<input type="hidden" name="id" value="<%= esc(editor.get("id")) %>"><input type="hidden" name="action" value="upload">
<label for="holiday-photo">Upload or replace cover photo</label><input id="holiday-photo" name="photo" type="file" accept="image/jpeg,image/png" required>
<small>JPEG or PNG · up to 5 MB and 24 megapixels. Landscape photos work best. Photo changes are saved separately.</small>
<button class="button primary" type="submit">Save cover photo</button></form>
<form method="post" action="<%= context %>/admin/holiday-image" onsubmit="return confirm('Remove the main cover photo?');">
<input type="hidden" name="csrf" value="<%= esc(session.getAttribute("holidayCsrf")) %>"><input type="hidden" name="id" value="<%= esc(editor.get("id")) %>"><input type="hidden" name="action" value="remove">
<button class="button" type="submit">Remove photo</button></form></div></div>
<% } else { %><p class="muted">Create the package first, then upload its main cover photo here.</p><% } %>
</section>
<% if (editing) { %>
<section class="card" id="holiday-gallery-admin"><div class="section-heading"><span>▦</span><div><h3>Holiday gallery</h3><p>Add up to 12 additional photos for the details page. Your main cover stays separate.</p></div></div>
<form method="post" enctype="multipart/form-data" action="<%= context %>/admin/holiday-image">
<input type="hidden" name="csrf" value="<%= esc(session.getAttribute("holidayCsrf")) %>"><input type="hidden" name="id" value="<%= esc(editor.get("id")) %>"><input type="hidden" name="action" value="uploadGallery">
<div class="form-grid"><label>Gallery photo<input type="file" name="photo" accept="image/jpeg,image/png" required><small>JPEG or PNG · up to 5 MB, 24 megapixels.</small></label><label>Caption (optional)<input name="caption" maxlength="200" placeholder="Describe the view or experience"></label></div><button class="button primary" type="submit">Add gallery photo</button></form>
<div class="holiday-admin-gallery">
<% List<Map<String,Object>> galleryPhotos=(List<Map<String,Object>>)request.getAttribute("gallery");
if(galleryPhotos!=null) for(Map<String,Object> photo:galleryPhotos) { %>
<figure><img src="<%= context %>/holiday-image?id=<%= esc(URLEncoder.encode(editor.get("id").toString(), StandardCharsets.UTF_8)) %>&amp;photo=<%= esc(photo.get("id")) %>" alt="<%= esc(photo.get("caption")) %>" loading="lazy" width="300" height="200"><figcaption><%= esc(photo.get("caption")) %></figcaption>
<form method="post" action="<%= context %>/admin/holiday-image" onsubmit="return confirm('Remove this gallery photo?');"><input type="hidden" name="csrf" value="<%= esc(session.getAttribute("holidayCsrf")) %>"><input type="hidden" name="id" value="<%= esc(editor.get("id")) %>"><input type="hidden" name="photoId" value="<%= esc(photo.get("id")) %>"><input type="hidden" name="action" value="removeGallery"><button class="button" type="submit">Remove photo</button></form></figure><% } %>
</div><% if(galleryPhotos==null || galleryPhotos.isEmpty()) { %><p class="muted">No extra gallery photos yet. Upload your first image above.</p><% } %></section>
<% } %>
<form method="post" action="<%= context %>/admin/holidays" id="holiday-form">
<input type="hidden" name="csrf" value="<%= esc(session.getAttribute("holidayCsrf")) %>">
<input type="hidden" name="action" value="<%= editing ? "save" : "create" %>">
<section class="card"><div class="section-heading"><span>01</span><div><h3>Package essentials</h3><p>The information travellers see when choosing their holiday.</p></div></div>
<div class="form-grid"><label>Package ID<input name="id" maxlength="80" pattern="[A-Za-z0-9_-]+" required value="<%= esc(editor.get("id")) %>" <%= editing ? "readonly" : "" %>><small>A unique ID such as honeymoon-kerala. Fixed after creation.</small></label>
<label>Visibility<select name="active"><option value="1" <%= !"0".equals(editor.get("active")) ? "selected" : "" %>>Published — available to book</option><option value="0" <%= "0".equals(editor.get("active")) ? "selected" : "" %>>Hidden — removed from catalogue</option></select></label>
<label class="full">Package name<input name="name" required maxlength="180" value="<%= esc(editor.get("name")) %>"></label>
<label>Occasion<input name="occasion" list="occasion-options" maxlength="80" required value="<%= esc(editor.get("occasion")) %>" placeholder="Birthday, Honeymoon, Anniversary…"><datalist id="occasion-options"><option>Birthday</option><option>Honeymoon</option><option>Anniversary</option><option>Family celebration</option><option>Friends getaway</option></datalist></label>
<label>Departure city<input name="departure_city" required maxlength="120" value="<%= esc(editor.get("departure_city")) %>"></label>
<label>Duration in days<input name="duration" id="holiday-duration" type="number" min="1" max="60" required value="<%= esc(editor.getOrDefault("duration","1")) %>"></label>
<label>Price per traveller (INR)<input name="price" type="number" min="0" max="2147483647" step="1" required value="<%= esc(editor.get("price")) %>"></label></div></section>
<section class="card"><div class="section-heading"><span>02</span><div><h3>The experience</h3><p>Describe what makes this occasion special and what the package includes.</p></div></div>
<label>Overview<textarea name="description" maxlength="15000" required rows="5"><%= esc(editor.get("description")) %></textarea></label>
<div class="form-grid"><label>Inclusions<textarea name="inclusions" maxlength="15000" required rows="5"><%= esc(editor.get("inclusions")) %></textarea></label>
<label>Exclusions<textarea name="exclusions" maxlength="15000" required rows="5"><%= esc(editor.get("exclusions")) %></textarea></label></div>
<label>Reference URL <small>(optional)</small><input type="url" name="source_url" maxlength="500" value="<%= esc(editor.get("source_url")) %>" placeholder="https://"></label></section>
<section class="card"><div class="section-heading"><span>03</span><div><h3>Day-by-day itinerary</h3><p>Write one description for each travel day. Use the arrows to reorder days.</p></div></div>
<div id="itinerary-days"><% for (int i=0;i<days.size();i++) { %><div class="itinerary-day"><div class="day-toolbar"><label for="day-<%= i %>">Day <%= i+1 %></label><div><button type="button" data-move="-1" aria-label="Move day up">↑</button><button type="button" data-move="1" aria-label="Move day down">↓</button><button type="button" data-remove>Remove</button></div></div><textarea id="day-<%= i %>" name="day" required maxlength="15000" rows="4"><%= esc(days.get(i)) %></textarea></div><% } %></div>
<button class="button" type="button" id="add-day">+ Add itinerary day</button><p class="muted" id="day-count" aria-live="polite">The itinerary must match the duration above.</p></section>
<div class="editor-save"><p id="save-state">Changes apply to the public package when saved.</p><button class="button primary" type="submit"><%= editing ? "Save changes" : "Create holiday" %></button></div>
</form></main></div></body></html>
