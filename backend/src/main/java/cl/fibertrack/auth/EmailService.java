package cl.fibertrack.auth;
import cl.fibertrack.config.FiberTrackProperties; import lombok.RequiredArgsConstructor; import org.springframework.mail.SimpleMailMessage; import org.springframework.mail.javamail.JavaMailSender; import org.springframework.scheduling.annotation.Async; import org.springframework.stereotype.Service;
@Service @RequiredArgsConstructor public class EmailService {
 private final JavaMailSender mail; private final FiberTrackProperties properties;
 @Async public void sendPasswordReset(String recipient,String rawToken){var message=new SimpleMailMessage();message.setFrom(properties.mailFrom());message.setTo(recipient);message.setSubject("Crear o recuperar contraseña de FiberTrack");message.setText("Abre FiberTrack y usa este enlace de un solo uso (válido 30 minutos):\n"+properties.publicUrl()+"/password-reset?token="+rawToken+"\n\nSi no solicitaste el cambio, ignora este mensaje.");mail.send(message);}
}
