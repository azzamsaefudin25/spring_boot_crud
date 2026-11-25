package com.example.demo.service;

import com.example.demo.entity.User;
import com.example.demo.dto.LoginUserRequest;
import com.example.demo.dto.TokenResponse;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ValidationService validationService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtService jwtService;

    @Transactional
    public TokenResponse login(LoginUserRequest request) {
        validationService.validate(request);

        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getUsername(),
                            request.getPassword()
                    )
            );
        } catch (AuthenticationException e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Username or password wrong");
        }

        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Username or password wrong"));

        String jwtToken = jwtService.generateToken(user);
        long expiresInSeconds = jwtService.getJwtExpiration() / 1000;

        return TokenResponse.builder()
                .accessToken(jwtToken)
                .tokenType("Bearer")
                .expiresIn(expiresInSeconds)
                .build();
    }

    public void logout(User user) {
        SecurityContextHolder.clearContext();
    }
}
