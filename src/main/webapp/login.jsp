<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    String loginType = (String) request.getAttribute("loginType");
    String tabParam = request.getParameter("tab");
    boolean isAdminTab = "admin".equalsIgnoreCase(loginType) || "admin".equalsIgnoreCase(tabParam);
    String redirectParam = request.getParameter("redirect");
    if (redirectParam == null) {
        redirectParam = "";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In & Admin Login | TravelTourism</title>
    <meta name="description" content="Sign in to your TravelTourism account or access admin login.">

    <!-- Google Fonts for elevated typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css?v=5">
</head>
<body class="auth-body">

    <!-- COMMON SITE HEADER -->
    <%@ include file="common/header.jsp" %>

    <main class="login-page">
        <div class="login-wrapper">

            <div class="login-card">

                <!-- Brand Card Header -->
                <div class="login-header">
                    <div class="auth-monogram" aria-hidden="true">TT</div>
                    <h1>Welcome <em>back</em></h1>
                    <p>Continue planning your journeys or sign in to your admin workspace.</p>
                </div>

                <!-- Error Notification -->
                <% if (error != null && !error.isBlank()) { %>
                    <div class="login-error" role="alert">
                        <svg class="error-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        <span><%= error %></span>
                    </div>
                <% } %>

                <!-- SEGMENTED TABS (User / Admin) -->
                <div class="login-tabs" role="tablist" aria-label="Login Options">
                    <button type="button"
                            id="userTab"
                            class="login-tab <%= !isAdminTab ? "active" : "" %>"
                            role="tab"
                            aria-selected="<%= !isAdminTab ? "true" : "false" %>"
                            aria-controls="userFormPanel"
                            onclick="showUserLogin()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <span>Traveller Account</span>
                    </button>

                    <button type="button"
                            id="adminTab"
                            class="login-tab <%= isAdminTab ? "active" : "" %>"
                            role="tab"
                            aria-selected="<%= isAdminTab ? "true" : "false" %>"
                            aria-controls="adminFormPanel"
                            onclick="showAdminLogin()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <span>Admin Login</span>
                    </button>
                </div>

                <!-- SLIDING WINDOW -->
                <div class="login-window">
                    <div class="login-slider <%= isAdminTab ? "show-admin" : "" %>" id="loginSlider">

                        <!-- ================= 01: TRAVELLER LOGIN ================= -->
                        <div class="login-form user-form" id="userFormPanel" role="tabpanel" aria-labelledby="userTab">
                            <div class="form-intro">
                                <h2>Traveller Sign In</h2>
                                <p>Access saved tours, booking confirmations and personal trips.</p>
                            </div>

                            <form action="${pageContext.request.contextPath}/user-login" method="post" autocomplete="on">
                                <input type="hidden" name="redirect" value="<%= redirectParam %>">

                                <div class="input-group">
                                    <label for="userEmail">Email Address</label>
                                    <div class="input-wrapper">
                                        <svg class="input-icon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                            <polyline points="22,6 12,13 2,6"></polyline>
                                        </svg>
                                        <input type="email"
                                               id="userEmail"
                                               name="email"
                                               placeholder="you@example.com"
                                               autocomplete="email"
                                               required>
                                    </div>
                                </div>

                                <div class="input-group">
                                    <div class="label-row">
                                        <label for="userPassword">Password</label>
                                    </div>
                                    <div class="input-wrapper password-wrapper">
                                        <svg class="input-icon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password"
                                               id="userPassword"
                                               name="password"
                                               placeholder="Enter your password"
                                               autocomplete="current-password"
                                               required>
                                        <button type="button"
                                                class="password-toggle-btn"
                                                onclick="togglePasswordVisibility('userPassword', this)"
                                                aria-label="Show password"
                                                title="Show password">
                                            <svg class="eye-show" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                            <svg class="eye-hide" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none;">
                                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                                <line x1="1" y1="1" x2="23" y2="23"></line>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <button type="submit" class="login-button user-submit-btn">
                                    <span>Sign In to Account</span>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </button>
                            </form>

                            <div class="auth-switch-prompt">
                                <span>New to TravelTourism?</span>
                                <a href="${pageContext.request.contextPath}/register.jsp" class="auth-accent-link">
                                    Create account
                                </a>
                            </div>
                        </div>

                        <!-- ================= 02: ADMIN LOGIN ================= -->
                        <div class="login-form admin-form" id="adminFormPanel" role="tabpanel" aria-labelledby="adminTab">
                            <div class="form-intro">
                                <h2>Admin Login</h2>
                                <p>Manage destination packages, guest bookings and site studio.</p>
                            </div>

                            <form action="${pageContext.request.contextPath}/admin-login" method="post" autocomplete="on">
                                <div class="input-group">
                                    <label for="adminUsername">Administrator Username</label>
                                    <div class="input-wrapper">
                                        <svg class="input-icon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="8.5" cy="7" r="4"></circle>
                                            <polyline points="17 11 19 13 23 9"></polyline>
                                        </svg>
                                        <input type="text"
                                               id="adminUsername"
                                               name="username"
                                               placeholder="Enter admin username"
                                               autocomplete="username"
                                               required>
                                    </div>
                                </div>

                                <div class="input-group">
                                    <div class="label-row">
                                        <label for="adminPassword">Administrator Password</label>
                                    </div>
                                    <div class="input-wrapper password-wrapper">
                                        <svg class="input-icon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password"
                                               id="adminPassword"
                                               name="password"
                                               placeholder="Enter admin password"
                                               autocomplete="current-password"
                                               required>
                                        <button type="button"
                                                class="password-toggle-btn"
                                                onclick="togglePasswordVisibility('adminPassword', this)"
                                                aria-label="Show password"
                                                title="Show password">
                                            <svg class="eye-show" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                            <svg class="eye-hide" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none;">
                                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                                <line x1="1" y1="1" x2="23" y2="23"></line>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <button type="submit" class="login-button admin-submit-btn">
                                    <span>Sign In as Admin</span>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <polyline points="9 18 15 12 9 6"></polyline>
                                    </svg>
                                </button>
                            </form>

                            <div class="auth-admin-note">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="16" x2="12" y2="12"></line>
                                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                </svg>
                                <span>Restricted to authorized team members and operations staff.</span>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

        </div>
    </main>

    <!-- COMMON SITE FOOTER -->
    <%@ include file="common/footer.jsp" %>

    <!-- INTERACTION SCRIPT -->
    <script>
        function showUserLogin() {
            const slider = document.getElementById("loginSlider");
            const userTab = document.getElementById("userTab");
            const adminTab = document.getElementById("adminTab");

            slider.classList.remove("show-admin");
            userTab.classList.add("active");
            userTab.setAttribute("aria-selected", "true");
            adminTab.classList.remove("active");
            adminTab.setAttribute("aria-selected", "false");

            const emailInput = document.getElementById("userEmail");
            if (emailInput) emailInput.focus();
        }

        function showAdminLogin() {
            const slider = document.getElementById("loginSlider");
            const userTab = document.getElementById("userTab");
            const adminTab = document.getElementById("adminTab");

            slider.classList.add("show-admin");
            userTab.classList.remove("active");
            userTab.setAttribute("aria-selected", "false");
            adminTab.classList.add("active");
            adminTab.setAttribute("aria-selected", "true");

            const usernameInput = document.getElementById("adminUsername");
            if (usernameInput) usernameInput.focus();
        }

        function togglePasswordVisibility(inputId, btn) {
            const input = document.getElementById(inputId);
            if (!input) return;

            const isPassword = input.type === "password";
            input.type = isPassword ? "text" : "password";

            const eyeShow = btn.querySelector(".eye-show");
            const eyeHide = btn.querySelector(".eye-hide");

            if (eyeShow && eyeHide) {
                eyeShow.style.display = isPassword ? "none" : "block";
                eyeHide.style.display = isPassword ? "block" : "none";
            }

            btn.setAttribute("aria-label", isPassword ? "Hide password" : "Show password");
            btn.setAttribute("title", isPassword ? "Hide password" : "Show password");
        }

        // Auto-focus first input on load
        window.addEventListener("DOMContentLoaded", () => {
            <% if (isAdminTab) { %>
                const adminField = document.getElementById("adminUsername");
                if (adminField) adminField.focus();
            <% } else { %>
                const userField = document.getElementById("userEmail");
                if (userField) userField.focus();
            <% } %>
        });
    </script>

</body>
</html>