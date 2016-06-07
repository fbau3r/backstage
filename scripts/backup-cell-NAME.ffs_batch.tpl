<!--
Replace all TODO XML-Comments with specific values,
then remove this XML-Comment
-->
<?xml version="1.0" encoding="UTF-8"?>
<FreeFileSync XmlFormat="5" XmlType="BATCH">
    <MainConfig>
        <Comparison>
            <Variant>TimeAndSize</Variant>
            <Symlinks>Exclude</Symlinks>
            <IgnoreTimeShift>2</IgnoreTimeShift>
        </Comparison>
        <SyncConfig>
            <Variant>Update</Variant>
            <CustomDirections>
                <LeftOnly>right</LeftOnly>
                <RightOnly>none</RightOnly>
                <LeftNewer>right</LeftNewer>
                <RightNewer>none</RightNewer>
                <Different>right</Different>
                <Conflict>none</Conflict>
            </CustomDirections>
            <DetectMovedFiles>false</DetectMovedFiles>
            <DeletionPolicy>Versioning</DeletionPolicy>
            <VersioningFolder Style="Replace"><!--TODO:TARGETFOLDER-->\_Revisions</VersioningFolder>
        </SyncConfig>
        <GlobalFilter>
            <Include>
                <Item>*</Item>
            </Include>
            <Exclude>
                <Item>\System Volume Information\</Item>
                <Item>\$Recycle.Bin\</Item>
                <Item>\RECYCLER\</Item>
                <Item>\RECYCLED\</Item>
                <Item>*\desktop.ini</Item>
                <Item>*\thumbs.db</Item>
                <Item>*\.thumbnails\</Item>
                <Item>*\.dthumb\</Item>
                <Item>*\.shared\</Item>
                <Item>*\.nomedia</Item>
            </Exclude>
            <TimeSpan Type="None">0</TimeSpan>
            <SizeMin Unit="None">0</SizeMin>
            <SizeMax Unit="None">0</SizeMax>
        </GlobalFilter>
        <FolderPairs>
            <Pair>
                <Left>mtp:\<!--TODO:PHONE-NAME-->\SD-Karte\DCIM</Left>
                <Right><!--TODO:TARGETFOLDER-->\DCIM</Right>
            </Pair>
        </FolderPairs>
        <OnCompletion/>
    </MainConfig>
    <BatchConfig>
        <HandleError>Popup</HandleError>
        <RunMinimized>true</RunMinimized>
        <LogfileFolder Limit="0"/>
    </BatchConfig>
</FreeFileSync>
