package Wiki.tn.Pages;
import java.time.Duration;
import java.util.List;
import org.openqa.selenium.JavascriptExecutor;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

import Helper.Config;
public class CableUSBPage {
	
	@FindBy(xpath ="/html/body/main/section/div/div/div[2]/section/section/div[3]/div/div/div/div/article/div/div[2]/h2/a")
	List<WebElement> ProductUSBCables;
	@FindBy(xpath ="//*[@id=\"add-to-cart-or-refresh\"]/div[2]/div/div[2]/button")
	WebElement addToCard;
	@FindBy(xpath= "/html/body/div[8]/div/div/div/div[2]/div/div/a")
	WebElement commander;

	@FindBy(xpath ="/html/body/main/section/div/div/div/section/div/div/div[1]/div[2]/ul/li[2]/div/div[2]/div[1]/a")
	WebElement panierContent;
	@FindBy(xpath="/html/body/main/section/div/div/div/section/div[1]/div[3]/div[3]/span")
	WebElement availiblty;
	
	@FindBy(id="selectProductSort")
	WebElement triproductselect;
	
	public CableUSBPage(WebDriver driver) {
		PageFactory.initElements(driver, this);
		
	}
	
	public void clickOnProductByName(String productName) {
		try {
		for(WebElement ProductUSBCable :ProductUSBCables) {
			if(ProductUSBCable.getText().contains(productName)) {
				Config.driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
				ProductUSBCable.click();
				Config.driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
				System.out.println(availiblty.getText());
				Assert.assertTrue(availiblty.getText().equals("En stock"));
 
				addToCard.click();
				WebDriverWait wait = new WebDriverWait(Config.driver,Duration.ofSeconds(5));
				wait.until(ExpectedConditions.elementToBeClickable(commander));
				commander.click();
				Config.driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
				Assert.assertTrue(panierContent.getText().contains(productName));
				
				
				
			
			}
		}
		}catch(Exception e) {

		}
	}
	public void triProductSortBy(String sortTri) {
		Select select = new Select(triproductselect);
		select.selectByVisibleText(sortTri);
		
	}

}
