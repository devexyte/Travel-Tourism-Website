<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Create Account | TravelTourism</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css?v=3">

    </head>

    <body class="auth-body">

        <!-- COMMON SITE HEADER -->
        <%@ include file="common/header.jsp" %>

        <main class="login-page">

            <div class="login-card register-card">

                <!-- Header -->
                <div class="login-header">

                    <h1>Create Your Account</h1>

                    <p>Join us and start planning your journey</p>

                </div>


                <!-- Error Message -->
                <% if (request.getAttribute("error") != null) {%>

                <div class="login-error">
                    <%= request.getAttribute("error")%>
                </div>

                <% }%>


                <!-- Registration Form -->
                <div class="login-form register-form">

                    <form action="${pageContext.request.contextPath}/register"
                          method="post"
                          id="registerForm">

                        <!-- Full Name -->
                        <div class="input-group">

                            <label for="fullName">
                                Full Name
                            </label>

                            <input type="text"
                                   id="fullName"
                                   name="fullName"
                                   placeholder="Enter your full name"
                                   maxlength="100"
                                   required>

                        </div>


                        <!-- Email -->
                        <div class="input-group">

                            <label for="email">
                                Email Address
                            </label>

                            <input type="email"
                                   id="email"
                                   name="email"
                                   placeholder="Enter your email address"
                                   maxlength="150"
                                   required>

                        </div>
                        <div class="input-group">
                            <label for="phone">Phone Number</label>

                            <input type="tel"
                                   id="phone"
                                   name="phone"
                                   maxlength="30"
                                   autocomplete="tel"
                                   placeholder="Enter your phone number"
                                   required>
                        </div>


                        <!-- Password -->
                        <div class="input-group password-group">

                            <label for="password">
                                Password
                            </label>

                            <input type="password"
                                   id="password"
                                   name="password"
                                   placeholder="Create a strong password"
                                   required>

                            <!-- Password Requirements -->
                            <div class="password-requirements">

                                <p class="requirements-title">
                                    Password must contain:
                                </p>

                                <div class="requirement" id="lengthRequirement">
                                    <span class="requirement-icon">✗</span>
                                    <span>At least 8 characters</span>
                                </div>

                                <div class="requirement" id="uppercaseRequirement">
                                    <span class="requirement-icon">✗</span>
                                    <span>At least 1 uppercase letter (A-Z)</span>
                                </div>

                                <div class="requirement" id="lowercaseRequirement">
                                    <span class="requirement-icon">✗</span>
                                    <span>At least 1 lowercase letter (a-z)</span>
                                </div>

                                <div class="requirement" id="numberRequirement">
                                    <span class="requirement-icon">✗</span>
                                    <span>At least 1 number (0-9)</span>
                                </div>

                                <div class="requirement" id="specialRequirement">
                                    <span class="requirement-icon">✗</span>
                                    <span>At least 1 special character (!@#$%^&*)</span>
                                </div>

                            </div>

                        </div>


                        <!-- Confirm Password -->
                        <div class="input-group">

                            <label for="confirmPassword">
                                Confirm Password
                            </label>

                            <input type="password"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   placeholder="Re-enter your password"
                                   required>

                            <div class="password-match"
                                 id="passwordMatch">
                            </div>

                        </div>


                        <!-- Create Account -->
                        <button type="submit"
                                class="login-button register-submit"
                                id="registerButton"
                                disabled>

                            Create Account

                        </button>

                    </form>


                    <!-- Login Link -->
                    <div class="register-link">

                        <span>Already have an account?</span>

                        <a href="${pageContext.request.contextPath}/login.jsp">
                            Login
                        </a>

                </div>

            </div>

        </main>

        <!-- COMMON SITE FOOTER -->
        <%@ include file="common/footer.jsp" %>


        <script>

            const password =
                    document.getElementById("password");

            const confirmPassword =
                    document.getElementById("confirmPassword");

            const registerButton =
                    document.getElementById("registerButton");


            // Requirement elements
            const lengthRequirement =
                    document.getElementById("lengthRequirement");

            const uppercaseRequirement =
                    document.getElementById("uppercaseRequirement");

            const lowercaseRequirement =
                    document.getElementById("lowercaseRequirement");

            const numberRequirement =
                    document.getElementById("numberRequirement");

            const specialRequirement =
                    document.getElementById("specialRequirement");

            const passwordMatch =
                    document.getElementById("passwordMatch");


            function updateRequirement(element, valid) {

                const icon =
                        element.querySelector(".requirement-icon");

                if (valid) {

                    element.classList.add("valid");
                    element.classList.remove("invalid");

                    icon.textContent = "✓";

                } else {

                    element.classList.add("invalid");
                    element.classList.remove("valid");

                    icon.textContent = "✗";
                }
            }


            function validatePassword() {

                const value = password.value;


                // Minimum 8 characters
                const hasLength =
                        value.length >= 8;


                // Uppercase
                const hasUppercase =
                        /[A-Z]/.test(value);


                // Lowercase
                const hasLowercase =
                        /[a-z]/.test(value);


                // Number
                const hasNumber =
                        /[0-9]/.test(value);


                // Special character
                const hasSpecial =
                        /[!@#$%^&*(),.?":{}|<>_\-+=/\\[\];'`~]/.test(value);


                updateRequirement(
                        lengthRequirement,
                        hasLength
                        );

                updateRequirement(
                        uppercaseRequirement,
                        hasUppercase
                        );

                updateRequirement(
                        lowercaseRequirement,
                        hasLowercase
                        );

                updateRequirement(
                        numberRequirement,
                        hasNumber
                        );

                updateRequirement(
                        specialRequirement,
                        hasSpecial
                        );


                return hasLength
                        && hasUppercase
                        && hasLowercase
                        && hasNumber
                        && hasSpecial;
            }


            function validateConfirmPassword() {

                const passwordValue =
                        password.value;

                const confirmValue =
                        confirmPassword.value;


                if (confirmValue === "") {

                    passwordMatch.textContent = "";

                    return false;
                }


                if (passwordValue === confirmValue) {

                    passwordMatch.textContent =
                            "✓ Passwords match";

                    passwordMatch.className =
                            "password-match success";

                    return true;

                } else {

                    passwordMatch.textContent =
                            "✗ Passwords do not match";

                    passwordMatch.className =
                            "password-match error";

                    return false;
                }
            }


            function validateForm() {

                const passwordValid =
                        validatePassword();

                const passwordsMatch =
                        validateConfirmPassword();


                registerButton.disabled =
                        !(passwordValid && passwordsMatch);
            }


            password.addEventListener(
                    "input",
                    validateForm
                    );


            confirmPassword.addEventListener(
                    "input",
                    validateForm
                    );

        </script>

    </body>

</html>