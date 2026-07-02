# APITOR: An API Analytics Engine(Frontend)

APITOR(Frontend) A user interface designed for the project APITOR, a tool to not only log details about the API performances but to visualize too to help finding the bottlenecks by tracking various metrics like Request Hits, Unique Ips , Http Method used, Status Codes returned and route -based latency and hits analysis.

* **Backend Core Engine Repository:** [🔗 Click here to view the Backend Repository](https://github.com/alokprajapat386/APITOR-Backend)

Want to intgrate your project key and start tracking your API, then follow this
* **Connector Repository:** [🔗 Click here to view the APITOR Connectors Templates](https://github.com/alokprajapat386/APITOR-Connector-Templates)

Core Architecture and Flow:
1.  A Splash Screen to show while the configurations and security keys are fethed from the secure storage.
2.  A landing page featuring the details about the APITOR like features,  tech stacks along with dynamic navigation buttons to navigate the user to dashboard or the login page accordingly.
3.  An Auth Screen integrated with Google OAuth for smooth login and register , A forgot password option that opens a Dialog and sends OTP to user via Email for verification
4.  A dashboard with Welcome and intro text along side some feature tiles.
5.  A project Page showing list of projects with details like project key , project id, project name, target URL and a Button to navigate to analytics page
6.  Metrics analytics page featuring project details, date time range selector, and a toggle switch for switching between perioidic and route based analytics.
7.  A setting page to allow user update their profile details like username, email and fullName, along side a changePassword option to open a Dialog  to change password securely.
8. In the end, a log out option that clears all the session details like jwt-token and user-details for a secure sign out.

## 🛠️ Tech Stack & Implementation

* **Framework:** Flutter / Dart (Optimized for cross-platform analytics display)
* **Authentication:** Google OAuth 2.0 Client integration & Custom Email-OTP flow
* **State & Storage:** Secure local storage for token/session retention

While only these very basic features for now, I will try to improve it and add some new features in future.
