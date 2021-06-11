import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;


public class bookQuery {
    
    public boolean AddBook(bookInfo book){
        Connection con = connection.getConnection();
        boolean isBookInserted = false;
        String query = "{CALL Add_Book(?, ?, ?, ?, ?, ?, ?, ?)}";
        
        
        try{
           
            CallableStatement ps = con.prepareCall(query);
            ps.setInt(1, book.getISBN());
            ps.setString(2, book.getTitle());
            ps.setInt(3, book.getPublication_year());
            ps.setInt(4, book.getPrice());
            ps.setString(5, book.getCategory());
            ps.setInt(6, book.getThreshold());
            ps.setString(7, book.getPublisher());
            ps.setInt(8, book.getCopies());
            
            if(ps.executeUpdate() != 0){
                JOptionPane.showMessageDialog(null, "new book has been added");
                isBookInserted = true;
            }
            else{
                JOptionPane.showMessageDialog(null, "invalid insertion");
            }
        } catch(SQLException ex){
            Logger.getLogger(bookQuery.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        /*//try insertion
        
        bookInfo book = new bookInfo(1, "AnimalFarm", 1980, 15, "Art", 2, "Tom", 5);
        bookQuery q = new bookQuery();
        boolean created = q.AddBook(book);
        System.out.println(created);
*/
        
        return isBookInserted;
    }
}
