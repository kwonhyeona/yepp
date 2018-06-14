package login;

import java.util.Random;

public class RandomAuthNumber {
	private int RandomAuthNum = 0;
	
	public RandomAuthNumber(){
		Random random = new Random();
	    
		int result = random.nextInt(10000000)+10000000;
		 
		if(result>10000000){
		    result = result - 10000000;
		}
		
		this.RandomAuthNum = result;
	}

	public int getRandomAuthNum() {
		return RandomAuthNum;
	}

	public void setRandomAuthNum(int randomAuthNum) {
		RandomAuthNum = randomAuthNum;
	}
	
	
}
