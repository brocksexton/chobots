update StuffType as T join Shop as S on T.shop_id=S.id set giftable=true where premium=true and S.name not in ("petGameShop", "petRestShop");
