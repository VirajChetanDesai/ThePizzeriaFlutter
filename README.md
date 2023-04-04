
# Pizzeria

Flutter based application , using firebase and Mysql for data storage and php as backend using XAMPP server.

## Features
Greeted with a login / sign up page for users , and also can be redirected to adminstrator login.

Has functionality to signup in using php API which sends required information to store in mysql.

Using another API we retrieve the information from mysql to check and authenticate existing user allowing them inside the application.

Similarly an adminstrator can login but not sign up into the application for security purposes.

The adminstrator has the ability to perform all CRUD operations
which include the ability to add new items into the menu , remove items from the menu and update the prices .

In order to maintain the size of the application all images are hosted on firebase from the admin upload screen , and retrieved using php whenever required.

The User has the ability to check all the products available and customise their order.

