
import java.sql.Connection;
import java.sql.DriverManager;

public class connection {
    public static Connection getConnection(){
        Connection con = null;
        String url = "jdbc:mysql://localhost:3306/bookstore?allowPublicKeyRetrieval=true&useSSL=false";
        String user = "root";
        String password = "root";

        try{
            con = DriverManager.getConnection(url, user, password);
        }
        catch (Exception ex){
            System.out.println(ex.getMessage());
              
        }
        return con;
    }
    
}
