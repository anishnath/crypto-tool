package z.y.x.Security;

import org.apache.commons.io.IOUtils;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;
import java.io.*;
import java.security.Security;
import java.util.Random;
import java.util.UUID;

/**
 * Created by aninath on 11/13/17.
 */
public class PBEUtils {



    public static String encodeBASE64(byte[] bytes) {
        return new BASE64Encoder().encode(bytes);
    }

    private static byte[] decodeBASE64(String text) throws IOException {
        //System.out.println("Text--" + text);

        return new BASE64Decoder().decodeBuffer(text);

    }

    public static String encrypt(final String message, final String password, final String algo, int rounds,final String salt) throws Exception {
        byte[] encryptedText = null;
        try {
            PBEKeySpec pbeKeySpec = new PBEKeySpec(password.toCharArray());
            SecretKeyFactory secretKeyFactory = SecretKeyFactory.getInstance(algo);
            SecretKey secretKey = secretKeyFactory.generateSecret(pbeKeySpec);

            PBEParameterSpec pbeParameterSpec = new PBEParameterSpec(salt.getBytes(), rounds);
            Cipher cipher = Cipher.getInstance(algo);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, pbeParameterSpec);
            encryptedText = cipher.doFinal(message.getBytes());

        } catch (Exception ex) {
            throw new Exception(ex);
        }

        return encodeBASE64(encryptedText);
    }

    public static String decrypt(final String message, final String password, final String algo, int rounds,final String salt) throws Exception {
        byte[] dectyptedText = null;
        try {
            PBEKeySpec pbeKeySpec = new PBEKeySpec(password.toCharArray());
            SecretKeyFactory secretKeyFactory = SecretKeyFactory.getInstance(algo);
            SecretKey secretKey = secretKeyFactory.generateSecret(pbeKeySpec);
            byte[] decryptMessage = decodeBASE64(message);
            PBEParameterSpec pbeParameterSpec = new PBEParameterSpec(salt.getBytes(), rounds);
            Cipher cipher = Cipher.getInstance(algo);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, pbeParameterSpec);
            dectyptedText = cipher.doFinal(decryptMessage);
        } catch (Exception ex) {
            throw new Exception(ex);
        }
        return new String(dectyptedText);

    }


    public static byte[] encryptFile(byte[] fisX, final String password, final String algo, int rounds) throws Exception {


        String path = System.getProperty("java.io.tmpdir");
        String fullPath = path + "/" + UUID.randomUUID().toString();
        byte[] b = null;
        //System.out.println(fullPath);
        try {
            FileOutputStream outFile = new FileOutputStream(fullPath);
            PBEKeySpec pbeKeySpec = new PBEKeySpec(password.toCharArray());
            SecretKeyFactory secretKeyFactory = SecretKeyFactory
                    .getInstance(algo);
            SecretKey secretKey = secretKeyFactory.generateSecret(pbeKeySpec);

            byte[] salt = new byte[8];
            Random random = new Random();
            random.nextBytes(salt);

            PBEParameterSpec pbeParameterSpec = new PBEParameterSpec(salt, rounds);
            Cipher cipher = Cipher.getInstance(algo);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, pbeParameterSpec);
            outFile.write(salt);

            byte[] output = cipher.doFinal(fisX);
            if (output != null)
                outFile.write(output);


            outFile.flush();
            outFile.close();

            FileInputStream fiss = new FileInputStream(fullPath);

            b = IOUtils.toByteArray(fiss);

            //Silently Delete the temprary File
            try {
                File file = new File(fullPath);
                file.delete();
            } catch (Exception ex) {
                //DO Nothing
            }
        }catch (Exception ex)
        {
            throw new Exception(ex);
        }

        return b;

    }


    public static byte[] decryptFile(InputStream fis, final String password, final String algo, int rounds) throws Exception {

        String path = System.getProperty("java.io.tmpdir");
        String fullPath = path + "/" + UUID.randomUUID().toString();
        byte[] b = null;
        //System.out.println(fullPath);

        try{
        PBEKeySpec pbeKeySpec = new PBEKeySpec(password.toCharArray());
        SecretKeyFactory secretKeyFactory = SecretKeyFactory
                .getInstance(algo);
        SecretKey secretKey = secretKeyFactory.generateSecret(pbeKeySpec);
        byte[] salt = new byte[8];
        fis.read(salt);
        PBEParameterSpec pbeParameterSpec = new PBEParameterSpec(salt, rounds);
        Cipher cipher = Cipher.getInstance(algo);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, pbeParameterSpec);
        FileOutputStream fos = new FileOutputStream(fullPath);
        byte[] in = new byte[64];
        int read;
        while ((read = fis.read(in)) != -1) {
            byte[] output = cipher.update(in, 0, read);
            if (output != null)
                fos.write(output);
        }

        byte[] output = cipher.doFinal();
        if (output != null)
            fos.write(output);

        fis.close();
        fos.flush();

        FileInputStream fiss = new FileInputStream(fullPath);
        b= IOUtils.toByteArray(fiss);

        //Silently Delete the temprary File
        try {
            File file = new File(fullPath);
            file.delete();
        }catch (Exception ex)
        {
            //DO Nothing
        }
        }catch (Exception ex)
        {

            throw new Exception(ex.getMessage());
        }


        return b;
    }

    byte[] concatenateByteArrays(byte[] a, byte[] b) {
        byte[] result = new byte[a.length + b.length];
        System.arraycopy(a, 0, result, 0, a.length);
        System.arraycopy(b, 0, result, a.length, b.length);
        return result;
    }

    public static void main(String[] args) throws Exception {
        String message = "anishNATH";
        String password = "anish";
        int round = 10;
        String algo = "PBEWITHSHA1ANDRC4_40";
        String salt="anisnnat";

        String encryped = PBEUtils.encrypt(message,password,algo,round,salt);
        //System.out.println(encryped);
        String decryped=  PBEUtils.decrypt(encryped,password,algo,round,salt);
        //System.out.println(decryped);


//        FileInputStream fis = new FileInputStream("/tmp/a.txt");
//        byte[] b = PBEUtils.encryptFile(IOUtils.toByteArray(fis),password,algo,round);
//
//        FileOutputStream fos = new FileOutputStream("/tmp/plainfile_decrypted.txt");
//        fos.write(b);


//        FileInputStream inFile = new FileInputStream("/tmp/plainfile.txt");
//        byte[] b = PBEUtils.encryptFile(IOUtils.toByteArray(inFile),password,algo,round);
//        FileOutputStream fos = new FileOutputStream("/tmp/des");
//        fos.write(b);

        InputStream str = new FileInputStream("/var/folders/13/pxs51m2d1f3gfs5pptxz3__m0000gn/T//49f3bc52-a2c0-412c-bf40-c84d50904dbe");
        byte[] b = PBEUtils.decryptFile(str, password, algo, round);
//        System.out.println(new String(b));


    }

}
