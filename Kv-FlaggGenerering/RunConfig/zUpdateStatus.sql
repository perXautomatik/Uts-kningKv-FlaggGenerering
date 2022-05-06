        INSERT INTO #statusTable
        select '',CURRENT_TIMESTAMP,@@ROWCOUNT
        --END TRY BEGIN CATCH SELECT 1 END CATCH else INSERT INTO @statusTable select 'preloading#DidNotDiscard',CURRENT_TIMESTAMP,@@ROWCOUNT