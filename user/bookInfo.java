package user;


public class bookInfo {  
    int ISBN;
    String title;
    int publication_year;
    int price;
    String category;
    int threshold;
    String publisher;
    int copies;

    public bookInfo(int ISBN, String title, int publication_year, int price, String category, int threshold, String publisher, int copies) {
        this.ISBN = ISBN;
        this.title = title;
        this.publication_year = publication_year;
        this.price = price;
        this.category = category;
        this.threshold = threshold;
        this.publisher = publisher;
        this.copies = copies;
    }

    public int getISBN() {
        return ISBN;
    }

    public void setISBN(int ISBN) {
        this.ISBN = ISBN;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getPublication_year() {
        return publication_year;
    }

    public void setPublication_year(int publication_year) {
        this.publication_year = publication_year;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getThreshold() {
        return threshold;
    }

    public void setThreshold(int threshold) {
        this.threshold = threshold;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public int getCopies() {
        return copies;
    }

    public void setCopies(int copies) {
        this.copies = copies;
    }
    
   
}
