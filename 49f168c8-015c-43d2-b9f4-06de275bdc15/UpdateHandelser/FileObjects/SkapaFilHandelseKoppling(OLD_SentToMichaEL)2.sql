update EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseFileObject
set recFileObjectID = utbyte.recFileObjectID
from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseFileObject
         inner join
     (select orginal.recHaendelseFileObjectID, utbyte.recFileObjectID
      from (select x.*,
                   arende.intDiarienummerLoepNummer aIntDiarienummerLoepNummer
            from EDPVisionRegionGotlandTest2.dbo.vwAehAerende arende
                     left outer join EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse handelse
                                     on arende.recAerendeID = handelse.recAerendeID
                     left outer join EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseFileObject x
                                     on x.recHaendelseID = handelse.recHaendelseID
            where arende.intDiarienummerLoepNummer in
                  (4340, 4348, 4349, 4351, 4352, 4357, 4358, 4362, 4364, 4365, 4366, 4367, 4373, 4375, 4380, 4381, 4383,
                   4388, 4390, 4395, 4396, 4398, 4400, 4401, 4404, 4407, 4413, 4417, 4418, 4419, 4420, 4422, 4432, 4433,
                   4439, 4441, 4443, 4445, 4452, 4454, 4458, 4465, 4468, 4472, 4473, 4481, 4482, 4483, 4484, 4486, 4498,
                   4499, 4503, 4506, 4510, 4512, 4513, 4515, 4517, 4518, 4519, 4533, 4538, 4539, 4544, 4546, 4551, 4570,
                   4575, 4580, 4581, 4582, 4585, 4590, 4596, 4601, 4602, 4605, 4610, 4612, 4614, 4616, 4619, 4623, 4625,
                   4629, 4631, 4634, 4635, 4636, 4637, 4638, 4639, 4642, 4645, 4646, 4653, 4657, 4660, 4661, 4666, 4672,
                   4675, 4676, 4685, 4687, 4702, 4705, 4709, 4714, 4718, 4722, 4723, 4726, 4728, 4730, 4740, 4742, 4747,
                   4752, 4753, 4754, 4755, 4756, 4764, 4766, 4769, 4772, 4773, 4778, 4782, 4785, 4786, 4792, 4795, 4807,
                   4811, 4812, 4813, 4815, 4816, 4817, 4818, 4819, 4821, 4822, 4826, 4827, 4833, 4835, 4838, 4839, 4846,
                   4850, 4851, 4852, 4855, 4856, 4860, 4861, 4863, 4867, 4868, 4871, 4872, 4873, 4884, 4894)
              and strDiarienummerSerie = 'mbnv'
              and strRubrik = N'Påminnelse om åtgärd - 24 månader') orginal
               left outer join
           (
               select z.strFileName,
                      case
                          when CHARINDEX('-', right(z.strFileName, 8)) = 4 then right(z.strFileName, 4)
                          else left(right(z.strFileName, 8), 4) end loepnummer,
                      x.recHaendelseFileObjectID,
                      x.recFileObjectID
               from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse handelse
                        left outer join EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseFileObject x
                                        on x.recHaendelseID = handelse.recHaendelseID
                        left outer join EDPVisionRegionGotlandTest2.dbo.vwEDPFileObject z
                                        on x.recFileObjectID = z.recFileObjectID
               where handelse.intRecnum = 440048
           ) utbyte on orginal.aIntDiarienummerLoepNummer = utbyte.loepnummer) utbyte
     on utbyte.recHaendelseFileObjectID = EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseFileObject.recHaendelseFileObjectID