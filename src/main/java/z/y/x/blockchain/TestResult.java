package z.y.x.blockchain;
import com.google.gson.Gson;

public class TestResult {
	public static void main(String[] args) {
		String json = "{\"result\":\"{\\\"publicKey\\\":\\\"168b84025ea37b25a1d878ab70e6fb783fdeb680782e629c1b1bc6bde0ec03ea4ca97b48ef2b7698ec53f45b9ddcc3b09f0d270f44bc6c2467e5fc45fcaaedef\\\",\\\"privateKey\\\":\\\"86133c513085e6d1edf37482cbf8d6ddc2b87bb6bbf5c52518c28dab74ec6a4e\\\",\\\"enr\\\":\\\"enode://168b84025ea37b25a1d878ab70e6fb783fdeb680782e629c1b1bc6bde0ec03ea4ca97b48ef2b7698ec53f45b9ddcc3b09f0d270f44bc6c2467e5fc45fcaaedef@10.10.0.0:30303?discport=0\\\"}\"}";

		Gson gson = new Gson();
		String result = gson.fromJson(json, ExampleResponse.class).getResult();

		System.out.println(result);
	}

	private static class ExampleResponse {
		private String result;

		public String getResult() {
			return result;
		}

		public void setResult(String result) {
			this.result = result;
		}
	}
}
