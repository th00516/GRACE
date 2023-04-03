core.data_filtering.act.pick_cell <- function(D, ctl1, ctl2, ctl3, ctl4, ctl5) {
  
  D$var$isUsed <-
    D$var$nCount >= ctl1[1] & D$var$nCount <= ctl1[2] & 
    D$var$nFeature >= ctl2[1] & D$var$nFeature <= ctl2[2] &
    D$var$pFeature.mt <= ctl3 &
    D$var$eActivity.actb >= ctl4[1] & D$var$eActivity.actb <= ctl4[2] &
    if (ctl5 == 'Yes') {D$var$SingletOrDoublet == 'Singlet'} else {
      D$var$SingletOrDoublet == 'Singlet' | D$var$SingletOrDoublet == 'Doublet'
    }
  
}