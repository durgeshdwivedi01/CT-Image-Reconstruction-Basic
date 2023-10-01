% Create a head phantom
phantom_image = phantom(256);
figure;
subplot(2,3,1);
imshow(phantom_image);
title('Original Phantom');

% Generate Sinogram
theta = 0:179;  % Projection angles
sinogram = radon(phantom_image, theta);

% Back Projection
reconstruction_backproj = iradon(sinogram, theta, 'linear', 'none');
subplot(2,3,2);
imshow(reconstruction_backproj, []);
title('Back Projection');

% Filtered Back Projection
reconstruction_filtered = iradon(sinogram, theta, 'linear', 'Ram-Lak');
subplot(2,3,3);
imshow(reconstruction_filtered, []);
title('Filtered Back Projection');

% ... [Previous code for creating the phantom, sinogram, back projection, and filtered back projection remains unchanged]

% Fourier Slice Theorem-based Reconstruction
F = fftshift(fft2(phantom_image));
reconstruction_fourier = real(ifft2(ifftshift(F)));
subplot(2,3,4);
imshow(reconstruction_fourier, []);
title('Fourier-based Reconstruction');

% Rudimentary Iterative Reconstruction (SIRT)
iterations = 10;
reconstruction_iterative = phantom_image; % Initial guess
for k = 1:iterations
    difference = radon(reconstruction_iterative, theta) - sinogram;
    correction = iradon(difference, theta, 'linear', 'none');
    
    % Resize the correction matrix
    correction_resized = imresize(correction, size(reconstruction_iterative));
    reconstruction_iterative = reconstruction_iterative - correction_resized;
end
subplot(2,3,5);
imshow(reconstruction_iterative, []);
title('Iterative (SIRT)');

% Final display adjustment
sgtitle('CT Image Reconstructions');
