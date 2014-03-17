package z.y.x.String;

public class LongestPalindrome {

	public static void main(String[] args) {
		String str = "ABCBAHELLOHOWRACECARAREYOUIAMAIDOINGGOOD";
		str = null;
		System.out.println("Longest Palindrome: "+longestPalindrome(str));
	}
	public static String longestPalindrome(String str){
		
		StringBuilder builder = new StringBuilder();
	
		String longestPalindrome = null;
		if(null==str)
			return builder.toString();
		else{
			longestPalindrome=str.substring(0,1);
			for(int i=0;i<str.length()-1;i++){
				String palindrome=expand(str,i,i);
				if(palindrome.length()> 1)
				{
					builder.append(palindrome);
					builder.append("\n");
				}
				//System.out.println(palindrome);
					
;				if(palindrome.length()>longestPalindrome.length()){
					longestPalindrome=palindrome;
				}
				
				palindrome=expand(str,i,i+1);
				if(palindrome.length()> 1)
				{
					builder.append(palindrome);
					builder.append("\n");
				}
					
				if(palindrome.length()>longestPalindrome.length()){
					longestPalindrome=palindrome;
				}
			}
		}
		builder.append("\n");
		builder.append("Longest Palindrome = " + longestPalindrome);
		return builder.toString();
		
	}
	static String expand(String str, int left, int right){
		if(left>right)
			return null;
		else{
			while(left>=0 && right<str.length()&&str.charAt(left)==str.charAt(right)){
				right++;
				left--;
			}
		}
		return str.substring(left+1,right);
		
	}
}