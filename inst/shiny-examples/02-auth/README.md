How it works:

1. The app generates a link to the authorizion page
1. Once user authorize the application, the user is redirected back to the app page with the addition of a URL parameter `code`: `http://example.com/path/to/app/?code=xxxx`
1. The app parses the `code` URL parameter using the `shiny::parseQueryString()` function
1. The app receives the access token credentials using a POST request
1. The app creates an object of class `httr::token2` which is used to query the API using the functions of the RGA package

To obtain OAuth 2.0 credentials for your application, complete these steps:

1. Creation of a new project (can be skipped if the project is already created):
    - Open the page <https://console.developers.google.com/project> in your favorite browser;
    - Click on **Create Project** blue button at the top left of the page;
    - Enter the name of the project into the **PROJECT NAME** field in the pop-up window;
    - Click **Create** to confirm the creation of the project.
2. Enabling access to the Google Analytics API:
    - Select your project from the project list on <https://console.developers.google.com/project page>;
    - Select **APIs & auth** and then **APIs** sub-menu in the left sidebar;
    - Click on the **Analytics API** link in the **Advertising APIs** section;
    - Click **Enable API** for activation **Analytics API**.
3. Creating a new application:
    - Select **APIs & auth** and then **Credentials** sub-menu in the left sidebar;
    - Click on **Add credentials** blue button at the top left of the page;
    - Select **OAuth 2.0 client ID** in the pop-up window;
    - Select **Web application ** from Application type list;
    - Change name of the client if you need;
    - Add exact URL where you application hosted in the **Authorized redirect URIs** field;
    - Click on the **Create** blue button to confirm the creation of the client ID.
4. Obtaining Client ID and Client secret:
    - Select the project from the project list on the <https://console.developers.google.com/project> page;
    - Select **APIs & auth** and then **Credentials** sub-menu in the left sidebar;
    - Click on name of the client from the **Name column** in the **OAuth 2.0 client IDs** table;
    - Click on the **Download JSON** button at the top and save this file as **creds.json** in the application root directory.

