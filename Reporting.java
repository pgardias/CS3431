// Daniel Sullivan and Przemek Gardias
// CS3431 Phase 3 JDBC

import java.sql.*;
import java.util.Scanner;

public class Reporting {

    static String username = "";
    static String password = "";
    static String queryNum = "";
    static Connection connection;
    static String driver = "oracle.jdbc.driver.OracleDriver";
    static String url = "jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl";

    public static boolean login() {
        try {
            Class.forName(driver);
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
        System.out.println("Driver is valid.");

        try {
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("Connecting to the database...");
        }
        catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        System.out.println("Login successful!");
        return true;
    }

    public static void runQuery(String cmd, String cmdNum) {
        try {
            Statement statement = connection.createStatement();
            String sqlCmd = null;
            String sqlCmd2 = null;
            String sqlCmd3 = null;

            if(cmdNum.equals("1")) {
                sqlCmd = "SELECT * FROM Patient WHERE patientSsn = '"+cmd+"'";
            }
            if(cmdNum.equals("2")) {
                sqlCmd = "SELECT * FROM Doctor WHERE docId = '"+cmd+"'";
            }
            if(cmdNum.equals("3")) {
                sqlCmd = "SELECT * FROM Admission WHERE admissionNum = "+cmd+"";
                sqlCmd2 = "SELECT DISTINCT roomNum, startDate, endDate FROM StayIn WHERE admissionNum = "+cmd+"";
                sqlCmd3 = "SELECT DISTINCT docId FROM Examine WHERE admissionNum = "+cmd+"";
            }
            System.out.println("\nRunning SQL command: " + sqlCmd + "\n");
            ResultSet queryResult = statement.executeQuery(sqlCmd);
            ResultSet queryResult2 = null;
            ResultSet queryResult3 = null;

            if(cmdNum.equals("3")) {
                System.out.println("Running SQL command: " + sqlCmd2);
                System.out.println("Running SQL command: " + sqlCmd3);
                System.out.println();
            }

            while(queryResult.next()) {
                if(cmdNum.equals("1")) {
                    System.out.println("Patient SSN: " + queryResult.getString("patientSsn"));
                    System.out.println("Patient First Name: " + queryResult.getString("firstName"));
                    System.out.println("Patient Last Name: " + queryResult.getString("lastName"));
                    System.out.println("Patient Address: " + queryResult.getString("address"));
                }
                if(cmdNum.equals("2")) {
                    System.out.println("Doctor ID: " + queryResult.getString("docId"));
                    System.out.println("Doctor First Name: " + queryResult.getString("firstName"));
                    System.out.println("Doctor Last Name: " + queryResult.getString("lastName"));
                    System.out.println("Doctor Gender: " + queryResult.getString("gender"));

                }
                if(cmdNum.equals("3")) {
                    System.out.println("Admission Number: " + queryResult.getString("admissionNum"));
                    System.out.println("Admission Date: " + queryResult.getString("admissionDate"));
                    System.out.println("Patient SSN: " + queryResult.getString("patientSsn"));
                    System.out.println("TotalPayment: " + queryResult.getString("totalPayment"));

                    System.out.println("Rooms:");

                    queryResult2 = statement.executeQuery(sqlCmd2);
                    while(queryResult2.next()) {
                        System.out.println("    RoomNum: " + queryResult2.getString("roomNum") + "  From Date: " + queryResult2.getString("startDate") + "  End Date: " + queryResult2.getString("endDate"));
                    }

                    System.out.println("Doctors examined the patient in this admission:");

                    queryResult3 = statement.executeQuery(sqlCmd3);
                    while(queryResult3.next()) {
                        System.out.println("    Doctor ID: " + queryResult3.getString("docId"));
                    }

                }
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void runUpdate(String aNum, String newTotal) {
        try {
            Statement statement = connection.createStatement();
            String sqlCmd = "UPDATE Admission SET totalPayment = " + newTotal + " WHERE admissionNum = " + aNum + "";
            System.out.println("Running SQL command: " + sqlCmd);
            statement.executeQuery(sqlCmd);
            System.out.println("\nSuccessfully updated admission number " + aNum + "'s total payment to $" + newTotal + ".");
        }
        catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public static void main(String[] args) {

        if(args.length < 2) {
            Scanner reader = new Scanner(System.in);
            System.out.print("Username: ");
            username = reader.next();
            System.out.print("Password: ");
            password = reader.next();
            System.out.print("Fucntion: ");
            queryNum = reader.next();
        }
        else {
            username = args[0];
            password = args[1];
        }

        if(!login()) {
            System.out.println("Login unsuccessful!");
        }

        if(args.length == 2) {
            System.out.println("1- Report Patients Basic Information");
            System.out.println("2- Report Doctors Basic Information");
            System.out.println("3- Report Admissions Information");
            System.out.println("4- Update Admissions Payment");
        }

        if(args.length == 3) {
            Scanner reader = new Scanner(System.in);
            queryNum = args[2];

            if(queryNum.equals("1")) {
                System.out.print("Enter Patient SSN: ");
                String patientSsn = reader.next();
                runQuery(patientSsn, "1");
            }
            else if(queryNum.equals("2")) {
                System.out.print("Enter Doctor ID: ");
                String docId = reader.next();
                runQuery(docId, "2");
            }
            else if(queryNum.equals("3")) {
                System.out.print("Enter Admission Number: ");
                String aNum = reader.next();
                runQuery(aNum, "3");
            }
            else if(queryNum.equals("4")) {
                System.out.print("Enter Admission Number: ");
                String aNum = reader.next();
                System.out.print("Enter the new total payment: ");
                String newTotal = reader.next();
                runUpdate(aNum, newTotal);
            }
            else {
                System.out.println("Invalid argument. Number must be between 1 and 4.");
                System.out.println("1- Report Patients Basic Information");
                System.out.println("2- Report Doctors Basic Information");
                System.out.println("3- Report Admissions Information");
                System.out.println("4- Update Admissions Payment");
            }
        }
        try {
            connection.close();
            System.out.println("\nDisconnected from the server.");
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
    }
}
