#!/usr/bin/env python
"""Quick Stan functionality test"""
import cmdstanpy
import sys
import os

try:
    # Compile model
    print("Compiling Stan model...")
    model = cmdstanpy.CmdStanModel(stan_file='test.stan')
    
    # Sample (fast - 1 chain, minimal iterations)
    print("Running inference...")
    fit = model.sample(
        data={}, 
        chains=1, 
        iter_warmup=50, 
        iter_sampling=50,
        show_progress=False,
        show_console=False
    )
    
    # Verify it worked
    assert fit is not None, "Sampling returned None"
    summary = fit.summary()
    assert 'y' in summary.columns or summary.index.name == 'name', "Missing parameter 'y'"
    
    print("✓ Stan test PASSED")
    sys.exit(0)
    
except Exception as e:
    print(f"✗ Stan test FAILED: {e}")
    sys.exit(1)