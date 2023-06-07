classdef Region < uint8
    % An enum for all of the RHR regions.
    % Each region is followed by RH or LH, meaning (R)ight/(L)eft
    % (H)emisphere. This is to distinguish from the naming convention of
    % stimulation where HL_R means stimulating the right hindlimb, but the
    % cortical response should be HL_LH.
    
    enumeration
      AC_RH   (1)  % Anterior Cingulate
      CG_RH   (2)  % Cingulate
      M2_RH   (3)  % Secondary Motor
      M1_RH   (4)  % Primary Motor
      FL_RH   (5)  % Forelimb
      HL_RH   (6)  % Hindlimb
      BC_RH   (7)  % Barrel Cortex
      TR_RH   (8)  % Trunk
      MO_RH   (9)  % Mouth
      NO_RH   (10) % Nose
      UNa_RH  (11) % Unassigned multimodal (anterior portion)
      UNb_RH  (12) % Unassigned multimodal (posterior portion)
      S2_RH   (13) % Secondary Somatosensory
      PTAa_RH (14) % Parietal association area (medial)
      PTAb_RH (15) % Parietal association area (lateral)
      RS_RH   (16) % Retrosplenial
      V1_RH   (17) % Primary visual
      AU_RH   (18) % Primary auditory
      TEA_RH  (19) % Temporal association
      AC_LH   (20)
      CG_LH   (21)
      M2_LH   (22)
      M1_LH   (23)
      FL_LH   (24)
      HL_LH   (25)
      BC_LH   (26)
      TR_LH   (27)
      MO_LH   (28)
      NO_LH   (29)
      UNa_LH  (30)
      UNb_LH  (31)
      S2_LH   (32)
      PTAa_LH (33)
      PTAb_LH (34)
      RS_LH   (35)
      V1_LH   (36)
      AU_LH   (37)
      TEA_LH  (38)
   end
end

