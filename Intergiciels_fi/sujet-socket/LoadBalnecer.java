import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Random;

public class LoadBalnecer implements Runnable
 
 {
static String hosts[] = {"localhost", "localhost"};
static int ports[] = {8081,8082};
static int nbHosts = 2;
static Random rand = new Random();
static Socket input;

public LoadBalnecer (Socket s) { 
    this.input = s;
}

	public static void main (String[] args) throws IOException {
		ServerSocket s = new ServerSocket(Integer.parseInt(args[0]));
		while (true) { new Thread(new LoadBalnecer(s.accept())).start(); }
	}
public void run() {
    try {
      int i = rand.nextInt(nbHosts);
      Socket sortie = new Socket (hosts[i],ports[i]);
      InputStream client_in = input.getInputStream();
      OutputStream client_out = input.getOutputStream();

      InputStream str_in = sortie.getInputStream();
      OutputStream str_out = sortie.getOutputStream();

      byte[] buffer = new byte[1024];

      int t_read = client_in.read(buffer);
      str_out.write(buffer, 0, t_read);

      t_read = str_in.read(buffer);
      client_out.write(buffer, 0 , t_read);

      sortie.close();





    }catch (IOException ex) {
        ex.printStackTrace();
    }
}
}
