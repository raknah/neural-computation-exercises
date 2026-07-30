module Instantaneous

using DSP

"""
    instantaneous(signal, fs; band)

Bandpass-filter `signal` into the frequency range `band = (f1, f2)` (Hz),
then compute its analytic signal. Returns `(phase, amplitude)`:

- `phase`: instantaneous phase (radians in [-π, π])
- `amplitude`: instantaneous amplitude (≥ 0)

Example:
```julia
phase, amp = instantaneous(sig, 1000; band=(6, 10))
"""
function instantaneous(signal::AbstractVector, fs::Real; band::Tuple)
    # 1. Bandpass filter design
    bp = Bandpass(band[1], band[2], fs = fs)
    filt = digitalfilter(bp, Butterworth(4))
    # 2. Apply zero-phase filter
    activity = filtfilt(filt, signal)

    # 3. Analytic signal
    analytic = hilbert(activity)

    # 4. Phase and amplitude
    phase = angle.(analytic)
    amplitude = abs.(analytic)

    return phase, amplitude
end
end # module