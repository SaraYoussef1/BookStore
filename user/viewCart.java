package user;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author sara
 */
public class viewCart extends javax.swing.JFrame {

    /**
     * Creates new form ManagerMode
     */
    public viewCart() {
        initComponents();
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jLabel4 = new javax.swing.JLabel();
        view_Item = new javax.swing.JButton();
        remove_Item = new javax.swing.JButton();
        prices = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/resources/rsz_3book(1).jpg"))); // NOI18N

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel1)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel2.setBackground(new java.awt.Color(51, 51, 51));

        jLabel4.setFont(new java.awt.Font("Chilanka", 1, 24)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(232, 236, 241));
        jLabel4.setText("Shopping Cart");

        view_Item.setBackground(new java.awt.Color(50, 50, 50));
        view_Item.setFont(new java.awt.Font("Chilanka", 1, 18)); // NOI18N
        view_Item.setForeground(new java.awt.Color(232, 236, 241));
        view_Item.setText("View items");
        view_Item.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                view_ItemActionPerformed(evt);
            }
        });

        remove_Item.setBackground(new java.awt.Color(50, 50, 50));
        remove_Item.setFont(new java.awt.Font("Chilanka", 1, 18)); // NOI18N
        remove_Item.setForeground(new java.awt.Color(232, 236, 241));
        remove_Item.setText(" Remove Item");
        remove_Item.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                remove_ItemActionPerformed(evt);
            }
        });

        prices.setBackground(new java.awt.Color(50, 50, 50));
        prices.setFont(new java.awt.Font("Chilanka", 1, 18)); // NOI18N
        prices.setForeground(new java.awt.Color(232, 236, 241));
        prices.setText("View prices");
        prices.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                pricesActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(view_Item)
                        .addGap(56, 56, 56)
                        .addComponent(prices)
                        .addGap(8, 8, 8))
                    .addComponent(jLabel4))
                .addGap(47, 47, 47)
                .addComponent(remove_Item)
                .addGap(39, 39, 39))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel4)
                .addGap(49, 49, 49)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(remove_Item)
                    .addComponent(prices)
                    .addComponent(view_Item))
                .addContainerGap(72, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void remove_ItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_remove_ItemActionPerformed

        remove_item form = new remove_item();
        form.setVisible(true);
        form.pack();
        form.setLocationRelativeTo(null);
        form.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setVisible(false);
    }//GEN-LAST:event_remove_ItemActionPerformed

    private void view_ItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_view_ItemActionPerformed
        // TODO add your handling code here:
        //open manager form
        login l = new login();
        int id = l.get_id();
        Connection con = connection.getConnection();
        String query = "{CALL VIEW_ITEMS (?)}";
        PreparedStatement p ;
        ResultSet rs;
        try {
            p = con.prepareStatement(query);
            p.setInt(1,id);
            rs = p.executeQuery();
            view_items form = new view_items();
            while (rs.next()){
                String ISBN_Result = String.valueOf(rs.getInt("ISBN"));
                String quantity_Result = String.valueOf(rs.getInt("QUANTITY"));
                String Title_Result = rs.getString("Title");
                String Publication_Year_Result = rs.getString("Publication_Year");
                String Price_Result = String.valueOf(rs.getInt("Price"));
                String Category_Result = rs.getString("Category");
                String Publisher_Name_Result = rs.getString("PUBLISHER_Name");
                String tdData[]={ISBN_Result,quantity_Result,Title_Result,Category_Result,Publisher_Name_Result,Publication_Year_Result,Price_Result};
                DefaultTableModel tblModel = (DefaultTableModel)form.Table.getModel();
                tblModel.addRow(tdData);
            }
            form.setVisible(true);
            form.pack();
            form.setLocationRelativeTo(null);
            form.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            this.setVisible(false);
        }
          
         catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage());
        }
        
    }//GEN-LAST:event_view_ItemActionPerformed

    private void pricesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_pricesActionPerformed
        // TODO add your handling code here:
        login l = new login();
        int id = l.get_id();
        Connection con = connection.getConnection();
        String query = "{CALL GET_PRICES (?)}";
        PreparedStatement p ;
        ResultSet rs;
        try {
            p = con.prepareStatement(query);
            p.setInt(1,id);
            rs = p.executeQuery();
            view_prices form = new view_prices();
            while (rs.next()){
                String Title_Result = rs.getString("Title");
                String Price_Result = String.valueOf(rs.getInt("Price*QUANTITY"));
                String tdData[]={Title_Result,Price_Result};
                DefaultTableModel tblModel = (DefaultTableModel)form.Table.getModel();
                tblModel.addRow(tdData);
            }
            query =  "{CALL TOTAL_PRICE (?)}";
            p = con.prepareStatement(query);
            p.setInt(1,id);
            rs = p.executeQuery();
            if(rs.next()){
                String total_ = String.valueOf(rs.getInt("TOTAL"));
                form.total.setText(total_);
            }
            form.setVisible(true);
            form.pack();
            form.setLocationRelativeTo(null);
            form.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            this.setVisible(false);
        }
          
         catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage());
        }
        
     
    }//GEN-LAST:event_pricesActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(viewCart.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(viewCart.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(viewCart.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(viewCart.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new viewCart().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JButton prices;
    private javax.swing.JButton remove_Item;
    private javax.swing.JButton view_Item;
    // End of variables declaration//GEN-END:variables
}