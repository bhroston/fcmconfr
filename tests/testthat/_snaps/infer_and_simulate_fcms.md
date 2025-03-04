# print.infer_conventional_fcm works

    Code
      print(test_infer)
    Output
      fcmconfr: conventional 
       $inference
         C1: 1
         C2: -0.1
         C3: 0
         C4: -0.07
         C5: 0.03
         C6: 0.02
       $inference_for_plotting
         - inference data transformed to streamline plotting with ggplot 
       $inference_state_vectors
         - inferences across all iterations of the simulation 
       $scenario_simulation
       $baseline_simulation

# print.infer_ivfn_or_tfn_fcm works

    Code
      test_sim
    Output
      infer_fcm: ivfn 
       $inferences_df
         : [1, 1] (1)
         : [-0.23, 0.09] (-0.23)
         : [0, 0] (0)
         : [-0.26, 0.13] (-0.26)
         : [-0.07, 0.16] (-0.07)
         : [-0.1, 0.11] (-0.1)
       $inferences_for_plotting
         - inference data transformed to streamline plotting with ggplot 
       $inference_state_vectors
         - inferences as fuzzy sets across all iterations of the simulation 
       $scenario_simulation
       $baseline_simulation

---

    Code
      print(ivfn_infer)
    Output
      infer_fcm: ivfn 
       $inferences_df
         : [1, 1] (1)
         : [-0.09, 0.22] (-0.09)
         : [-0.12, 0.11] (-0.12)
       $inferences_for_plotting
         - inference data transformed to streamline plotting with ggplot 
       $inference_state_vectors
         - inferences as fuzzy sets across all iterations of the simulation 
       $scenario_simulation
       $baseline_simulation

---

    Code
      print(tfn_infer)
    Output
      infer_fcm: tfn 
       $inferences_df
         A: [1, 1, 1] (1)
         B: [-0.09, 0.07, 0.22] (-0.09)
         C: [-0.12, -0.01, 0.11] (-0.12)
       $inferences_for_plotting
         - inference data transformed to streamline plotting with ggplot 
       $inference_state_vectors
         - inferences as fuzzy sets across all iterations of the simulation 
       $scenario_simulation
       $baseline_simulation

