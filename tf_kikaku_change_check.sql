SELECT
  A.HOSOWAKUID
  ,A.HOSOWAKURIREKIID
  ,A.CURRENTFLAG
  ,A.KIKAKUID   
  ,A.HOSODANID 
  ,A.TYPEID  
  ,A.WAKUSTATUS   
FROM
  (SELECT DISTINCT
 　　　　　　　　T1.HOSOWAKUID         
   　　　　,T1.HOSOWAKURIREKIID  
   　　　　,T1.CURRENTFLAG       
　　　　　　　　　　,T1.KIKAKUID         
　　　　　　　　　　,T1.HOSODANID         
　　　　　　　　　　,T1.TYPEID           
　　　　　　　　　　,T2.WAKUSTATUS        
　　　　　　FROM
　　　　　　　　　　　HOSOWAKU T1
　　　　　　FULL OUTER JOIN
　　　　　　　　　　　WAKUINFO T2
　　　　　　ON　
   　　　　　T2.HOSOWAKUID = T1.HOSOWAKUID
　　　　　　AND
   　　　　　T2.HOSOWAKURIREKIID = T1.HOSOWAKURIREKIID
　　　　　　WHERE
　　　　　　　　　　　T1.UPDATEDATE >= (sysdate - INTERVAL '1' HOUR)
　　　　　　AND
　　　　　　　　　　　T2.WAKUSTATUS = 7
　　　　　　ORDER BY
　　　　　　　　　　　T1.HOSOWAKUID
　　　　　　　　　　　,T1.HOSOWAKURIREKIID)A
FULL OUTER JOIN
  (SELECT DISTINCT
   　　　　T1.HOSOWAKUID         
　　　　　　　　　　,T1.HOSOWAKURIREKIID  
　　　　　　　　　　,T1.CURRENTFLAG       
　　　　　　　　　　,T1.KIKAKUID         
　　　　　　　　　　,T1.HOSODANID         
　　　　　　　　　　,T1.TYPEID            
　　　　　　　　　　,T2.WAKUSTATUS        
　　　　　　FROM
　　　　　　　　　　HOSOWAKU T1
　　　　　　FULL OUTER JOIN
　　　　　　　　　　WAKUINFORIREKI T2
　　　　　　ON
　　　　　　　　 T2.HOSOWAKUID = T1.HOSOWAKUID
　　　　　　AND
　　　　　　　　　　T2.HOSOWAKURIREKIID = T1.HOSOWAKURIREKIID
　　　　　　WHERE
　　　　　　　　　　T1.HOSOWAKUID IN
	　　(SELECT
	　　　　　　　　T1.HOSOWAKUID 
	　　　　FROM 
	　　　　　　　　HOSOWAKU T1 
	　　　　FULL OUTER JOIN
	　　　　　　 WAKUINFO T2
	　　　　ON
	　　　　　　　　T2.HOSOWAKUID = T1.HOSOWAKUID
	　　　　AND
	　　　　　　　　T2.HOSOWAKURIREKIID = T1.HOSOWAKURIREKIID
	　　　　WHERE 
	　　　　　　　　T1.UPDATEDATE >= (sysdate - INTERVAL '1' HOUR) 
	　　　　AND 
	　　　　　　　　T2.WAKUSTATUS = 7)
　　　　　　　AND 
　　　　　　　　　　T2.WAKUSTATUS = 5
　　　　　　　ORDER BY
　　　　　　　　　　T1.HOSOWAKUID
　　　　　　　　　　,T1.HOSOWAKURIREKIID)B
ON
  A.HOSOWAKUID = B.HOSOWAKUID
WHERE
  A.KIKAKUID = B.KIKAKUID
AND
  A.HOSODANID = B.HOSODANID
AND
  A.TYPEID = B.TYPEID
ORDER BY
  A.HOSOWAKUID 
  ,A.HOSOWAKURIREKIID;
