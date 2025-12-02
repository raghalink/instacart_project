SELECT table_name,
       (xpath('/row/count/text()', xml_count))[1]::text::int AS row_count
FROM (
    SELECT table_name,
           query_to_xml(format('SELECT COUNT(*) AS count FROM instacart.%I', table_name),
                         false, true, '') AS xml_count
    FROM information_schema.tables
    WHERE table_schema = 'instacart'
      AND table_type = 'BASE TABLE'
) t
ORDER BY row_count DESC;