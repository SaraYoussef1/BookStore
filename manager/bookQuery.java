package manager;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLWarning;
import javax.swing.JOptionPane;
import user.bookInfo;
import user.connection;


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
            JOptionPane.showMessageDialog(null, ex.getMessage());
        }
        
        /*//try insertion
        
        bookInfo book = new bookInfo(1, "AnimalFarm", 1980, 15, "Art", 2, "Tom", 5);
        bookQuery q = new bookQuery();
        boolean created = q.AddBook(book);
        System.out.println(created);
*/
        
        return isBookInserted;
    }
    
    
    
    public boolean ModifyBook(bookInfo book, boolean modify_copies){
        Connection con = connection.getConnection();
        boolean isBookInserted = false;
        String query = "{CALL Modify_Book(?, ?, ?, ?, ?, ?, ?, ?)}";
        int temp1;
        String temp2;
        
        try{
           
            CallableStatement ps = con.prepareCall(query);
            temp1 = book.getISBN();
            if(temp1 == -1)
                ps.setNull(1, java.sql.Types.INTEGER);
            else
              ps.setInt(1, temp1);
            
            temp2 = book.getTitle();
            if(temp2 == " ")
                ps.setNull(2, java.sql.Types.VARCHAR);
            else
                ps.setString(2, temp2);
            
            temp1 = book.getPublication_year();
            if(temp1 == -1)
                ps.setNull(3, java.sql.Types.INTEGER);
            else
              ps.setInt(3, temp1);
            
            temp1 = book.getPrice();
            if(temp1 == -1)
                ps.setNull(4, java.sql.Types.INTEGER);
            else
              ps.setInt(4, temp1);
            
           temp2 = book.getCategory();
            if(temp2 == " ")
                ps.setNull(5, java.sql.Types.VARCHAR);
            else
                ps.setString(5, temp2);
            
           temp1 = book.getThreshold();
            if(temp1 == -1)
                ps.setNull(6, java.sql.Types.INTEGER);
            else
              ps.setInt(6, temp1);
            
           temp2 = book.getPublisher();
            if(temp2 == " ")
                ps.setNull(7, java.sql.Types.VARCHAR);
            else
                ps.setString(7, temp2);
            
            temp1 = book.getCopies();
            if(temp1 == -1 && !modify_copies)
                ps.setNull(8, java.sql.Types.INTEGER);
            else
              ps.setInt(8, temp1);
            
            if(ps.executeUpdate() != 0){
                JOptionPane.showMessageDialog(null, "book has been modified");
                isBookInserted = true;
            }
            else{
                JOptionPane.showMessageDialog(null, "invalid modification");
            }
        } catch(SQLException ex){
            JOptionPane.showMessageDialog(null, ex.getMessage());
        }
        
        /*//try insertion
        
        bookInfo book = new bookInfo(1, "AnimalFarm", 1980, 15, "Art", 2, "Tom", 5);
        bookQuery q = new bookQuery();
        boolean created = q.AddBook(book);
        System.out.println(created);
*/
        
        return isBookInserted;
    }
    
    private boolean checkNull(Object temp){
        if(temp == null)
            return true;
        else
            return false;
    }
}

