function dft = make_dft(magnitude, phse)
    % changing the phase, necessitates recalculating the FFT result.
    % transforming the equations given in the notes results in the these equations
    % to calculate the real and imaginary components:
    %   R^2 = F^2 / (1 + tan^2(phi))
    %   I = R tan(phi)
    R = sqrt(magnitude.^2 ./ (1 + tan(phse).^2));
    I = R .* tan(phse);
    dft = complex(R, I);
end

