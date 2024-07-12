ALTER session SET current_schema=JDGWORKFLOWAPP;

CREATE OR REPLACE FORCE VIEW JDGWORKFLOWAPP.V_INSTANCE_DATA_NEW ("processContextId", "processingBatchId", "clientId", "clientServer", "confidenceFactor", "fileLandingDatetime", "hierarchyReleaseUuid", "ingestPath", "isMetadataIdentified", "isReconciliationComplete", "indirectCompletedAtDirect", "origFileName", "productBuilderPriority", "serviceId", "systemPriority", "topicNumbers", "xampexFileName", "xampexFileLocation", "requestType", "requestReceivedTime", "saId", "sourceArtifactId", "deltaTextNotesUuid","acquisitionCourtCategory", "acquisitionCourtId", "acquisitionProductId", "acquisitionProductName", "acquisitionProductType", "acquisitionProviderLogin", "acquisitionProviderName","rebroadcastReasonCode", "hasImage", "hasTable", "isSupportingDocument", "pdfUuid", "pdfUri", "docketUri", "westlawLink", "expertNames", "pdfUriRoot", "receiptId", "receiptDate", "receiptMethod", "sourceFileFormat", "sourceFileName", "originatingProductType", "originatingSourceId", "originatingSourcePdfUuid", "originatingSourcePdfUri", "initialLoadTime", "sourceXmlUuid", "confidenceFactorQL", 
  "manuallySourced", "reasonCode", "jaId", "artifactUuid", "artifactDescriptorId", "artifactFamilyUuid", "artifactGroupId", "artifactGroupDesc", "artifactPriority", "artifactPriorityStatus", "artifactSubTypeId", "artifactSubTypeDesc", "artifactTypeId", "artifactTypeDesc", "caseSlug", "contentShortTitle", "contentLongTitle", "filedDate", "artifactFormat", "headnoteCount", "jurisdiction", "legacyArtifactUuid", "novusUuid", "pageCount", "primaryDate", "productStage", "publishingFormatName", "publishingLocation", "serialNumber", "venueShortName", "pubFormatReason", "pubFormatReasonUpdated", "enhancementLevel", "westlawCitation", "isHotArtifact", "isRushArtifact", "isMarkman", "isBankruptcy", "isEdEnhancementRequired", "isIndirectHistoryRequired", "isContentReviewRequired", "isRevisorReviewRequired", "hasQuery", "hasNotes", "processingPriority", "processingPriorityOverride", "pdfCompositionUUID", "officialCite", "docketNumber", "lowPriority", 
  "subjectGroup", "subjectSubgroup", "subjectType", "specialityCategory", "specialtyGroup", "confidenceFactorVA", "confidenceFactorPrint", "pbVaDtMmr", "pbPrintDtMmr","pbRetroDtMmr","confidenceFactorRetro", "diId", "documentUuid", "docFamilyUuid", "docketType", "relationshipReview", "courtline", "docketCreatedDate", "docketReceiptDate", "docketFiledDate", "fileLocation", "ceId", "changeEventProcessRef", "changeEventResourceType", "changeType", "eventType", "changeEventTopicQueue", "changeEventResourceId", "changeEventArtifactUuid", "summaryArtifactUuid", "changeEventCreatedTime", "changeEventReceivedTime", "changeEventProcessedCreated", "PID",
  "processInstanceId", "processExecutionId", "processDescription", "parentProcessInstanceId", "processDefId", "processName", "processType", "processPathwayLocation", "processStartTime", "processEndTime", "processInitiator", "processStatus", "isAsyncProcess", "isDetachedProcess", "processCreatedTime", "tId", "taskInstanceId", "parentTaskInstanceId", "taskDefKey", "taskExecutionId", "taskName", "taskAltName", "taskAssignee", "taskClaimTime", "taskExternalClaim", "taskCompletedTime", "taskDue", "taskCategoryName", "taskAction", "taskStatus", "queryStatus", "taskCreatedTime", "abortedBy", "qualityStatus", "sentToReviewBy","taskInitialLaunchTime", "userLocation", "siteResponsible", "CTID", "classifier", "classificationIsActive", "classificationIsCriminal", "classificationIteration", "classificationClaimedBy", "classificationSummarizer", "classificationCategoryName", "classificationTopicData", "classificationCreatedDate", 
  "astId", "suggestionId", "suggestionTerm", "suggestionComment", "suggestionAttributeName", "suggestedBy", "suggestionActiveStatus", "suggestionCreatedDate", "qtId", "queryAssignedToGroup", "queryRequestor", "queryResponder", "queryQuestionCategory", "queryQuestionText", "queryAnswer", "queryDetail", "queryAction", "drtId", "duplicateCount", "duplicateList", "duplicateReviewerComment", "duplicateAction", "atId", "topicalAreasRemaining", "topicalAreaHnCounts", "topicalAreasAi", "atIsOrphan", "sentToAttributeReviewBy", "serviceRequestId", "correlationId", "serviceRequestBatchId", "serviceRequestServiceId", "serviceRequestProcessId", "serviceStageIdentifier", "serviceStartTime", "serviceEndTime", "serviceRequestStatusCode", "serviceCreatedDate","serviceWestLawTime")
AS
  SELECT R1."processContextId",
    R1."processingBatchId",
    R1."clientId",
    R1."clientServer",
    R1."confidenceFactor",
    R1."fileLandingDatetime",
    R1."hierarchyReleaseUuid",
    R1."ingestPath",
    R1."isMetadataIdentified",
    R1."isReconciliationComplete",
    R1."indirectCompletedAtDirect",
    --R1."hasQuery",R1."hasNotes",R1."origFileName",R1."processingPriority",
    R1."origFileName",
    R1."productBuilderPriority",
    R1."serviceId",
    R1."systemPriority",
    R1."topicNumbers",
    R1."xampexFileName",
    R1."xampexFileLocation",
    R1."requestType",
    R1."requestReceivedTime",
    R1."saId",
    R1."sourceArtifactId",
	R1."deltaTextNotesUuid",
    R1."acquisitionCourtCategory",
    R1."acquisitionCourtId",
    R1."acquisitionProductId",
    R1."acquisitionProductName",
    R1."acquisitionProductType",
    R1."acquisitionProviderLogin",
    R1."acquisitionProviderName",
    R1."rebroadcastReasonCode",
    R1."hasImage",
    R1."hasTable",
    R1."isSupportingDocument",
    R1."pdfUuid",
    R1."pdfUri",
    R1."docketUri",
    R1."westlawLink",
    R1."expertNames",
    R1."pdfUriRoot",
    R1."receiptId",
    R1."receiptDate",
    R1."receiptMethod",
    R1."sourceFileFormat",
    R1."sourceFileName",
    R1."originatingProductType",
    R1."originatingSourceId",
    R1."originatingSourcePdfUuid",
    R1."originatingSourcePdfUri",
    R1."initialLoadTime",
    R1."sourceXmlUuid",
    R1."confidenceFactorQL",
    R1."manuallySourced",
    R1."reasonCode",
    --R1."jaId",R1."artifactUuid",R1."artifactDescriptorId",R1."artifactFamilyUuid",R1."artifactGroupId",R1."artifactGroupDesc",R1."artifactPriority",R1."artifactPriorityStatus",R1."artifactSubTypeId",R1."artifactSubTypeDesc",R1."artifactTypeId",R1."artifactTypeDesc",R1."caseSlug",R1."contentShortTitle",R1."filedDate",R1."artifactFormat",R1."headnoteCount",R1."jurisdiction",R1."legacyArtifactUuid",R1."pageCount",R1."primaryDate",R1."productStage",R1."publishingFormatName",R1."publishingLocation",R1."serialNumber",R1."venueShortName",R1."pubFormatReason", R1."pubFormatReasonUpdated", R1."enhancementLevel",R1."westlawCitation",R1."isHotArtifact",R1."isRushArtifact",R1."isMarkman",R1."isBankruptcy",R1."isEdEnhancementRequired",R1."isIndirectHistoryRequired",R1."isContentReviewRequired",R1."isRevisorReviewRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.TJA_ID
      ELSE PJA.ID
    END) AS "jaId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_UUID
      ELSE PJA.ARTIFACT_UUID
    END) AS "artifactUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_DESCRIPTOR_ID
      ELSE PJA.ARTIFACT_DESCRIPTOR_ID
    END) AS "artifactDescriptorId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_FAMILY_UUID
      ELSE PJA.ARTIFACT_FAMILY_UUID
    END) AS "artifactFamilyUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_GROUP_ID
      ELSE PJA.ARTIFACT_GROUP_ID
    END) AS "artifactGroupId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_GROUP_DESC
      ELSE PJA.ARTIFACT_GROUP_DESC
    END) AS "artifactGroupDesc",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_PRIORITY
      ELSE PJA.ARTIFACT_PRIORITY
    END) AS "artifactPriority",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_PRIORITY_STATUS
      ELSE PJA.ARTIFACT_PRIORITY_STATUS
    END) AS "artifactPriorityStatus",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_SUB_TYPE_ID
      ELSE PJA.ARTIFACT_SUB_TYPE_ID
    END) AS "artifactSubTypeId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_SUB_TYPE_DESC
      ELSE PJA.ARTIFACT_SUB_TYPE_DESC
    END) AS "artifactSubTypeDesc",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_TYPE_ID
      ELSE PJA.ARTIFACT_TYPE_ID
    END) AS "artifactTypeId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_TYPE_DESC
      ELSE PJA.ARTIFACT_TYPE_DESC
    END) AS "artifactTypeDesc",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CASE_SLUG
      ELSE PJA.CASE_SLUG
    END) AS "caseSlug",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONTENT_SHORT_TITLE
      ELSE PJA.CONTENT_SHORT_TITLE
    END) AS "contentShortTitle",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONTENT_LONG_TITLE
      ELSE PJA.CONTENT_LONG_TITLE
    END) AS "contentLongTitle",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.FILED_DATE
      ELSE PJA.FILED_DATE
    END) AS "filedDate",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.FORMAT
      ELSE PJA.FORMAT
    END) AS "artifactFormat",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.HEADNOTE_COUNT
      ELSE PJA.HEADNOTE_COUNT
    END) AS "headnoteCount",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.JURISDICTION
      ELSE PJA.JURISDICTION
    END) AS "jurisdiction",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.LEGACY_ARTIFACT_UUID
      ELSE PJA.LEGACY_ARTIFACT_UUID
    END) AS "legacyArtifactUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.NOVUS_UUID
      ELSE PJA.NOVUS_UUID
    END) AS "novusUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PAGE_COUNT
      ELSE PJA.PAGE_COUNT
    END) AS "pageCount",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PRIMARY_DATE
      ELSE PJA.PRIMARY_DATE
    END) AS "primaryDate",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PRODUCT_STAGE
      ELSE PJA.PRODUCT_STAGE
    END) AS "productStage",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PUBLISHING_FORMAT_NAME
      ELSE PJA.PUBLISHING_FORMAT_NAME
    END) AS "publishingFormatName",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PUBLISHING_LOCATION
      ELSE PJA.PUBLISHING_LOCATION
    END) AS "publishingLocation",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SERIAL_NUMBER
      ELSE PJA.SERIAL_NUMBER
    END) AS "serialNumber",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.VENUE_SHORT_NAME
      ELSE PJA.VENUE_SHORT_NAME
    END) AS "venueShortName",
    (
	CASE
	   WHEN R1.TJA_ID IS NOT NULL
	   THEN R1.PUB_FORMAT_REASON
	   ELSE PJA.PUB_FORMAT_REASON
	END) AS "pubFormatReason",
	(CASE
	   WHEN R1.TJA_ID IS NOT NULL
	   THEN R1.PUB_FORMAT_REASON_UPDATED
	   ELSE PJA.PUB_FORMAT_REASON_UPDATED
	END) AS "pubFormatReasonUpdated",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ENHANCEMENT_LEVEL
      ELSE PJA.ENHANCEMENT_LEVEL
    END) AS "enhancementLevel",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.WESTLAW_CITATION
      ELSE PJA.WESTLAW_CITATION
    END) AS "westlawCitation",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_HOT_ARTIFACT
      ELSE PJA.IS_HOT_ARTIFACT
    END) AS "isHotArtifact",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_RUSH_ARTIFACT
      ELSE PJA.IS_RUSH_ARTIFACT
    END) AS "isRushArtifact",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_MARKMAN
      ELSE PJA.IS_MARKMAN
    END) AS "isMarkman",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_BANKRUPTCY
      ELSE PJA.IS_BANKRUPTCY
    END) AS "isBankruptcy",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_ED_ENHANCEMENT_REQ
      ELSE PJA.IS_ED_ENHANCEMENT_REQ
    END) AS "isEdEnhancementRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_IND_HIST_REQ
      ELSE PJA.IS_IND_HIST_REQ
    END) AS "isIndirectHistoryRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_CONTENT_REVIEW_REQ
      ELSE PJA.IS_CONTENT_REVIEW_REQ
    END) AS "isContentReviewRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_REVISOR_REVIEW_REQ
      ELSE PJA.IS_REVISOR_REVIEW_REQ
    END) AS "isRevisorReviewRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.HAS_QUERY
      ELSE PJA.HAS_QUERY
    END) AS "hasQuery",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.HAS_NOTES
      ELSE PJA.HAS_NOTES
    END) AS "hasNotes",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PROCESSING_PRIORITY
      ELSE PJA.PROCESSING_PRIORITY
    END) AS "processingPriority",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PROCESSING_PRIORITY_OVERRIDE
      ELSE PJA.PROCESSING_PRIORITY
    END) AS "processingPriorityOverride",
	(
	CASE
      WHEN R1.TJA_ID IS NOT NULL
	  THEN R1.PDF_COMPOSITION_UUID
	  ELSE PJA.PDF_COMPOSITION_UUID		
	END) AS "pdfCompositionUUID",
	(
	CASE
      WHEN R1.TJA_ID IS NOT NULL
	  THEN R1.OFFICIAL_CITE
	  ELSE PJA.OFFICIAL_CITE		
	END) AS "officialCite",
	(
	CASE
      WHEN R1.TJA_ID IS NOT NULL
	  THEN R1.DOCKET_NUMBER
	  ELSE PJA.DOCKET_NUMBER		
	END) AS "docketNumber",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.LOW_PRIORITY
      ELSE PJA.LOW_PRIORITY
    END) AS "lowPriority",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SUBJECT_GROUP
      ELSE PJA.SUBJECT_GROUP
    END) AS "subjectGroup",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SUBJECT_SUBGROUP
      ELSE PJA.SUBJECT_SUBGROUP
    END) AS "subjectSubgroup",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SUBJECT_TYPE
      ELSE PJA.SUBJECT_TYPE
    END) AS "subjectType",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SPECIALITY_CATEGORY
      ELSE PJA.SPECIALITY_CATEGORY
    END) AS "specialityCategory",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SPECIALTY_GROUP
      ELSE PJA.SPECIALTY_GROUP
    END) AS "specialtyGroup",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONFIDENCE_FACTOR_VA
      ELSE PJA.CONFIDENCE_FACTOR_VA
    END) AS "confidenceFactorVA",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONFIDENCE_FACTOR_PRINT
      ELSE PJA.CONFIDENCE_FACTOR_PRINT
    END) AS "confidenceFactorPrint",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PB_VA_DT_MMR
      ELSE PJA.PB_VA_DT_MMR
    END) AS "pbVaDtMmr",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PB_PRINT_DT_MMR
      ELSE PJA.PB_PRINT_DT_MMR
    END) AS "pbPrintDtMmr",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PB_RETRO_DT_MMR
      ELSE PJA.PB_RETRO_DT_MMR
    END) AS "pbRetroDtMmr",
	(
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONFIDENCE_FACTOR_RETRO
      ELSE PJA.CONFIDENCE_FACTOR_RETRO
    END) AS "confidenceFactorRetro",
	R1."diId",
	R1."documentUuid",
    R1."docFamilyUuid",
    R1."docketType",
	R1."relationshipReview",
	R1."courtline",
    R1."docketCreatedDate",
    R1."docketReceiptDate",
	R1."docketFiledDate",
    R1."fileLocation",
    R1."ceId",
    R1."changeEventProcessRef",
    R1."changeEventResourceType",
    R1."changeType",
    R1."eventType",
    R1."changeEventTopicQueue",
    R1."changeEventResourceId",
    R1."changeEventArtifactUuid",
    R1."summaryArtifactUuid",
    R1."changeEventCreatedTime",
    R1."changeEventReceivedTime",
    R1."changeEventProcessedCreated",
    R1."PID",
    R1."processInstanceId",
    R1."processExecutionId",
    R1."processDescription",
    R1."parentProcessInstanceId",
    R1."processDefId",
    R1."processName",
    R1."processType",
    R1."processPathwayLocation",
    R1."processStartTime",
    R1."processEndTime",
    R1."processInitiator",
    R1."processStatus",
    R1."isAsyncProcess",
    R1."isDetachedProcess",
    R1."processCreatedTime",
    R1."tId",
    R1."taskInstanceId",
    R1."parentTaskInstanceId",
    R1."taskDefKey",
    R1."taskExecutionId",
    R1."taskName",
    R1."taskAltName",
    R1."taskAssignee",
    R1."taskClaimTime",
    R1."taskExternalClaim",
    R1."taskCompletedTime",
    R1."taskDue",
    R1."taskCategoryName",
    R1."taskAction",
    R1."taskStatus",
    R1."queryStatus",
    R1."taskCreatedTime",
    R1."abortedBy",
    R1."qualityStatus",
    R1."sentToReviewBy",
    R1."taskInitialLaunchTime",
    R1."userLocation",
	R1."siteResponsible",
    R1."CTID",
    R1."classifier",
    R1."classificationIsActive",
    R1."classificationIsCriminal",
    R1."classificationIteration",
    R1."classificationClaimedBy",
    R1."classificationSummarizer",
    R1."classificationCategoryName",
    R1."classificationTopicData",
    R1."classificationCreatedDate",
    R1."ASTID",
    R1."suggestionId",
    R1."suggestionTerm",
    R1."suggestionComment",
    R1."suggestionAttributeName",
    R1."suggestedBy",
    R1."suggestionActiveStatus",
    R1."suggestionCreatedDate",
    R1."qtId",
    R1."queryAssignedToGroup",
    R1."queryRequestor",
    R1."queryResponder",
    R1."queryQuestionCategory",
    R1."queryQuestionText",
    R1."queryAnswer",
    R1."queryDetail",
    R1."queryAction",
    R1."drtId",
    R1."duplicateCount",
    R1."duplicateList",
    R1."duplicateReviewerComment",
    R1."duplicateAction",
    R1."atId",
    R1."topicalAreasRemaining",
    R1."topicalAreaHnCounts",
    R1."topicalAreasAi",
    R1."atIsOrphan",
	R1."sentToAttributeReviewBy",
    R1."serviceRequestId",
    R1."correlationId",
    R1."serviceRequestBatchId",
    R1."serviceRequestServiceId",
    R1."serviceRequestProcessId",
    R1."serviceStageIdentifier",
    R1."serviceStartTime",
    R1."serviceEndTime",
    R1."serviceRequestStatusCode",
    R1."serviceCreatedDate",
    R1."serviceWestLawTime"
  FROM
    ( SELECT DISTINCT
      -- Process Context
      pc.PROCESS_CONTEXT_ID         AS "processContextId",
      pc.BATCH_ID                   AS "processingBatchId",
      pc.CLIENT_ID                  AS "clientId",
      pc.CLIENT_SERVER              AS "clientServer",
      pc.CONFIDENCE_FACTOR          AS "confidenceFactor",
      pc.FILE_LANDING_DATETIME      AS "fileLandingDatetime",
      pc.HIERARCHY_RELEASE_UUID     AS "hierarchyReleaseUuid",
      pc.INGEST_PATH                AS "ingestPath",
      pc.IS_METADATA_IDENTIFIED     AS "isMetadataIdentified",
      pc.IS_RECONCILIATION_COMPLETE AS "isReconciliationComplete",
      pc.IH_COMP_AT_DH              AS "indirectCompletedAtDirect",
      --          pc.HAS_QUERY AS "hasQuery",
      --          pc.HAS_NOTES AS "hasNotes",
      pc.ORIG_FILE_NAME AS "origFileName",
      --          pc.PROCESSING_PRIORITY AS "processingPriority",
      pc.PRODUCT_BUILDER_PRIORITY "productBuilderPriority",
      pc.SERVICE_ID           AS "serviceId",
      pc.SYSTEM_PRIORITY      AS "systemPriority",
      pc.TOPIC_NUMBERS        AS "topicNumbers",
      pc.XAMPEX_FILE_NAME     AS "xampexFileName",
      pc.XAMPEX_FILE_LOCATION AS "xampexFileLocation",
      pc.REQUEST_TYPE         AS "requestType",
      pc.CREATED_DATE         AS "requestReceivedTime",
      -- Source Artifact
      sa.ID                         AS "saId",
      sa.SOURCE_ARTIFACT_ID         AS "sourceArtifactId",
	  sa.DELTA_TEXT_NOTES_UUID      AS "deltaTextNotesUuid",
      sa.ACQUISITION_COURT_CATEGORY AS "acquisitionCourtCategory",
      sa.ACQUISITION_COURT_ID       AS "acquisitionCourtId",
      sa.ACQUISITION_PRODUCT_ID     AS "acquisitionProductId",
      sa.ACQUISITION_PRODUCT_NAME   AS "acquisitionProductName",
      sa.ACQUISITION_PRODUCT_TYPE   AS "acquisitionProductType",
      sa.ACQUISITION_PROVIDER_LOGIN AS "acquisitionProviderLogin",
      sa.ACQUISITION_PROVIDER_NAME  AS "acquisitionProviderName",
      sa.REBROADCAST_REASON_CODE    AS "rebroadcastReasonCode",
      sa.HAS_IMAGE                  AS "hasImage",
      sa.HAS_TABLE                  AS "hasTable",
      sa.IS_SUPPORTING_DOCUMENT     AS "isSupportingDocument",
      sa.PDF_UUID                   AS "pdfUuid",
      sa.PDF_URI                    AS "pdfUri",
      sa.DOCKET_URI					AS "docketUri",
      sa.WL_LINK					AS "westlawLink",
      sa.EXPERT_NAMES				AS "expertNames",
      sa.PDF_URI_ROOT               AS "pdfUriRoot",
      sa.RECEIPT_ID                 AS "receiptId",
      sa.RECEIPT_DATE               AS "receiptDate",
      sa.RECEIPT_METHOD             AS "receiptMethod",
      sa.SOURCE_FILE_FORMAT         AS "sourceFileFormat",
      sa.SOURCE_FILE_NAME           AS "sourceFileName",
      sa.ORIG_PRODUCT_TYPE          AS "originatingProductType",
      sa.ORIG_SOURCE_ID             AS "originatingSourceId",
      sa.ORIG_SOURCE_PDF_UUID       AS "originatingSourcePdfUuid",
      sa.ORIG_SOURCE_PDF_URI        AS "originatingSourcePdfUri",
      sa.INITIAL_LOAD_TIME       	AS "initialLoadTime",
      sa.SOURCE_XML_UUID        	AS "sourceXmlUuid",
      sa.CONFIDENCE_FACTOR_QL		AS "confidenceFactorQL",
      sa.MANUALLY_SOURCED			AS "manuallySourced",      
      sa.REASON_CODE				AS "reasonCode",
      -- Judicial Artifact
      ja.*,
      --Docket Info
      di.ID						   AS "diId",
	  di.DOCUMENT_UUID             AS "documentUuid",
      di.DOC_FAMILY_UUID           AS "docFamilyUuid",
      di.DOCKET_TYPE               AS "docketType",	 
	  di.RELATIONSHIP_REVIEW	   AS "relationshipReview",
	  di.COURTLINE				   AS "courtline",
	  di.CREATED_DATE              AS "docketCreatedDate",
	  di.RECEIPT_DATE              AS "docketReceiptDate",
      di.FILED_DATE           	   AS "docketFiledDate",
      di.FILE_LOCATION             AS "fileLocation",
      -- Change Event
      ce.CHANGE_EVENT_ID           AS "ceId",
      ce.PROCESS_ID_REF            AS "changeEventProcessRef",
      ce.RESOURCE_TYPE             AS "changeEventResourceType",
      ce.CHANGE_TYPE               AS "changeType",
      ce.EVENT_TYPE                AS "eventType",
      ce.TOPIC                     AS "changeEventTopicQueue",
      ce.RESOURCE_ID               AS "changeEventResourceId",
      ce.ARTIFACT_UUID             AS "changeEventArtifactUuid",
      ce.SUMMARY_ARTIFACT_UUID     AS "summaryArtifactUuid",
      ce.CHANGE_EVENT_CREATED_TIME AS "changeEventCreatedTime",
      ce.RECEIVED_TIME             AS "changeEventReceivedTime",
      ce.PROCESS_CREATED           AS "changeEventProcessedCreated",
      -- Process
      p.ID                         AS pId,
      p.PROCESS_INSTANCE_ID        AS "processInstanceId",
      p.EXECUTION_ID               AS "processExecutionId",
      p.DESCRIPTION                AS "processDescription",
      p.PARENT_PROCESS_INSTANCE_ID AS "parentProcessInstanceId",
      p.PROCESS_DEF_ID             AS "processDefId",
      p.NAME                       AS "processName",
      p.TYPE                       AS "processType",
      p.PATHWAY_LOCATION           AS "processPathwayLocation",
      p.START_TIME                 AS "processStartTime",
      p.END_TIME                   AS "processEndTime",
      p.INITIATOR_ID               AS "processInitiator",
      p.STATUS                     AS "processStatus",
      p.IS_ASYNC                   AS "isAsyncProcess",
      p.IS_DETACHED                AS "isDetachedProcess",
      p.CREATED_DATE               AS "processCreatedTime",
      p.JA_ID                      AS PJA_ID,
      p.SR_ID					   AS sr_id,
      -- Task
      t.ID                      AS "tId",
      t.TASK_INSTANCE_ID        AS "taskInstanceId",
      t.PARENT_TASK_INSTANCE_ID AS "parentTaskInstanceId",
      t.TASK_DEF_KEY            AS "taskDefKey",
      t.EXECUTION_ID            AS "taskExecutionId",
      t.NAME                    AS "taskName",
      t.ALT_NAME                AS "taskAltName",
      t.ASSIGNEE                AS "taskAssignee",
      t.CLAIM_TIME              AS "taskClaimTime",
      t.EXTERNAL_CLAIM          AS "taskExternalClaim",
      t.COMPLETED_TIME          AS "taskCompletedTime",
      t.TASK_DUE                AS "taskDue",
      t.CATEGORY_NAME           AS "taskCategoryName",
      t.TASK_ACTION             AS "taskAction",
      t.STATUS                  AS "taskStatus",
      t.QUERY_STATUS            AS "queryStatus",
      t.CREATED_DATE            AS "taskCreatedTime",
      t.ABORTED_BY              AS "abortedBy",
      t.QUALITY_STATUS          AS "qualityStatus",
      t.SENT_TO_REVIEW_BY       AS "sentToReviewBy",
      t.TASK_INITIAL_LAUNCH		AS "taskInitialLaunchTime",
      t.USER_LOCATION			AS "userLocation",
	  t.SITE_RESPONSIBLE 		AS "siteResponsible",
      t.JA_ID                   AS TJA_ID,
      -- classification task
      ct.ID                                    AS ctId,
      ct.CLASSIFIER                            AS "classifier",
      ct.IS_ACTIVE                             AS "classificationIsActive",
      ct.IS_CRIMINAL                           AS "classificationIsCriminal",
      ct.ITERATION                             AS "classificationIteration",
      ct.CLAIMED_BY                            AS "classificationClaimedBy",
      ct.SUMMARIZER                            AS "classificationSummarizer",
      ct.TASK_CATEGORY_NAME                    AS "classificationCategoryName",
      DBMS_LOB.SUBSTR (ct.TOPIC_DATA, 4000, 1) AS "classificationTopicData",
      ct.CREATED_DATE                          AS "classificationCreatedDate",
      -- att suggestion task
      ast.ID 					AS astId,
	  ast.SUGGESTION_ID 		AS "suggestionId",
      ast.SUGGESTION_TERM 		AS "suggestionTerm",
      ast.SUGGESTION_COMMENT 	AS "suggestionComment",
      ast.ATTRIBUTE_NAME 		AS "suggestionAttributeName",
      ast.SUGGESTED_BY 			AS "suggestedBy",
      ast.ACTIVE_STATUS 		AS "suggestionActiveStatus",
      ast.REFRESH_DATE 			AS "suggestionCreatedDate",
      -- query task
      qt.ID                AS "qtId",
      qt.ASSIGNED_TO_GROUP AS "queryAssignedToGroup",
      qt.REQUESTOR         AS "queryRequestor",
      qt.RESPONDER         AS "queryResponder",
      qt.QUESTION_CATEGORY AS "queryQuestionCategory",
      Rtrim(Replace(qt.QUESTION_TEXT , CHR(0), ' '))     AS "queryQuestionText",
      qt.ANSWER            AS "queryAnswer",
      qt.DETAIL            AS "queryDetail",
      qt.ACTION_TO_TAKE    AS "queryAction",
      -- duplicate review task
      drt.ID               AS "drtId",
      drt.DUPE_COUNT       AS "duplicateCount",
      drt.DUPE_LIST        AS "duplicateList",
      drt.REVIEWER_COMMENT AS "duplicateReviewerComment",
      drt.ACTION_TO_TAKE   AS "duplicateAction",
      -- attribute task
      at.ID               			AS "atId",
      at.TOPICAL_AREAS_REMAINING    AS "topicalAreasRemaining",
      at.TOPICAL_AREA_HN_COUNTS    	AS "topicalAreaHnCounts",
      at.TOPICAL_AREAS_AI 			AS "topicalAreasAi",
      at.IS_ORPHAN   				AS "atIsOrphan",
	  at.SENT_TO_ATTRIBUTE_REVIEW_BY	AS "sentToAttributeReviewBy",
      --service request
      sr.ID           AS "serviceRequestId",
      sr.CORRELATION_ID     AS "correlationId",
      sr.BATCH_ID           AS "serviceRequestBatchId",
      sr.SERVICE_ID         AS "serviceRequestServiceId",
      sr.PROCESS_ID         AS "serviceRequestProcessId",
      sr.STAGE_IDENTIFIER   AS "serviceStageIdentifier",
      sr.SERVICE_START_TIME AS "serviceStartTime",
      sr.SERVICE_END_TIME   AS "serviceEndTime",
      sr.STATUS_CODE        AS "serviceRequestStatusCode",
      sr.CREATED_DATE       AS "serviceCreatedDate",
      sr.WESTLAW_TIME       AS "serviceWestLawTime"
    FROM process_context pc,
      judicial_artifact ja,
      source_artifact sa,
      process p,
      docket_info di,
      change_event ce,
      task t,
      classification_task ct,
      att_suggestion_task ast,
      query_task qt,
      duplicate_review_task drt,
      attributes_task at,
      service_request sr
    WHERE pc.process_context_id        = p.process_context_id
    AND t.ja_id                        = ja.id(+)
    AND pc.process_context_id          = sa.process_context_id(+)
    AND pc.process_context_id 		   = di.process_context_id(+)
    AND pc.process_context_id          = ce.process_context_id(+)
    AND p.id                           = t.process_id
    AND p.sr_id						   = sr.id(+)
    AND t.task_instance_id             = ct.task_instance_id(+)
    AND t.task_instance_id             = ast.task_instance_id(+)
    AND t.task_instance_id             = qt.task_instance_id(+)
    AND t.task_instance_id             = drt.task_instance_id(+)
    AND t.task_instance_id             = at.task_instance_id(+)
    AND COALESCE(pc.is_archived, 'N') <> 'Y'
    ) R1,
    judicial_artifact pja
  WHERE R1.pja_id                = pja.id(+);
  /
    
  CREATE OR REPLACE SYNONYM JDGWORKFLOW_USER.V_INSTANCE_DATA_NEW FOR JDGWORKFLOWAPP.V_INSTANCE_DATA_NEW;
  GRANT
  SELECT ON JDGWORKFLOWAPP.V_INSTANCE_DATA_NEW TO JDGWORKFLOW_USER;
  /
  
  CREATE OR REPLACE FORCE VIEW JDGWORKFLOWAPP.V_GLOBAL_SEARCH_NEW ("processContextId", "processingBatchId", "clientId", "clientServer", "confidenceFactor", "fileLandingDatetime", "hierarchyReleaseUuid", "ingestPath", "isMetadataIdentified", "isReconciliationComplete", "indirectCompletedAtDirect", "origFileName", "productBuilderPriority", "serviceId", "systemPriority", "topicNumbers", "xampexFileName", "xampexFileLocation", "requestType", "requestReceivedTime", "saId", "sourceArtifactId","deltaTextNotesUuid", "acquisitionCourtCategory", "acquisitionCourtId", "acquisitionProductId", "acquisitionProductName", "acquisitionProductType", "acquisitionProviderLogin", "acquisitionProviderName","rebroadcastReasonCode", "hasImage", "hasTable", "isSupportingDocument", "pdfUuid", "pdfUri", "docketUri", "westlawLink", "expertNames", "pdfUriRoot", "receiptId", "receiptDate", "receiptMethod", "sourceFileFormat", "sourceFileName", "originatingProductType", "originatingSourceId", "originatingSourcePdfUuid", "originatingSourcePdfUri", "initialLoadTime", "sourceXmlUuid", "confidenceFactorQL", "manuallySourced", "reasonCode", "jaId", "artifactUuid", "artifactDescriptorId", "artifactFamilyUuid",
  "artifactGroupId", "artifactGroupDesc", "artifactPriority", "artifactPriorityStatus", "artifactSubTypeId", "artifactSubTypeDesc", "artifactTypeId", "artifactTypeDesc", "caseSlug", "contentShortTitle", "contentLongTitle", "filedDate", "artifactFormat", "headnoteCount", "jurisdiction", "legacyArtifactUuid", "novusUuid", "pageCount", "primaryDate", "productStage", "publishingFormatName", "publishingLocation", "serialNumber", "venueShortName", "pubFormatReason", "pubFormatReasonUpdated", "enhancementLevel", "westlawCitation", "isHotArtifact", "isRushArtifact", "isMarkman", "isBankruptcy", "isEdEnhancementRequired", "isIndirectHistoryRequired", "isContentReviewRequired", "isRevisorReviewRequired", "hasQuery", "hasNotes", "processingPriority", "processingPriorityOverride", "pdfCompositionUUID", "officialCite", "docketNumber", "lowPriority", "subjectGroup", "subjectSubgroup", "subjectType", "specialityCategory", "specialtyGroup", "confidenceFactorVA", "confidenceFactorPrint", "pbVaDtMmr", "pbPrintDtMmr","pbRetroDtMmr","confidenceFactorRetro", "diId", "documentUuid", "docFamilyUuid", "docketType", "relationshipReview", "courtline", "docketCreatedDate", "docketReceiptDate", "docketFiledDate", "fileLocation", "ceId", "changeEventProcessRef", "changeEventResourceType", "changeType", "eventType", "changeEventTopicQueue", "changeEventResourceId", "changeEventArtifactUuid", "summaryArtifactUuid", "changeEventCreatedTime", "changeEventReceivedTime", "changeEventProcessedCreated", "PID",
  "processInstanceId", "processExecutionId", "processDescription", "parentProcessInstanceId", "processDefId", "processName", "processType", "processPathwayLocation", "processStartTime", "processEndTime", "processInitiator", "processStatus", "isAsyncProcess", "isDetachedProcess", "processCreatedTime", "tId", "taskInstanceId", "parentTaskInstanceId", "taskDefKey", "taskExecutionId", "taskName", "taskAltName", "taskAssignee", "taskClaimTime", "taskExternalClaim", "taskCompletedTime", "taskDue", "taskCategoryName", "taskAction", "taskStatus", "queryStatus", "taskCreatedTime", "abortedBy", "qualityStatus", "sentToReviewBy","taskInitialLaunchTime", "userLocation", "siteResponsible", "CTID", "classifier", "classificationIsActive", "classificationIsCriminal", "classificationIteration", "classificationClaimedBy", "classificationSummarizer", "classificationCategoryName", "classificationTopicData", "classificationCreatedDate", 
  "astId", "suggestionId", "suggestionTerm", "suggestionComment", "suggestionAttributeName", "suggestedBy", "suggestionActiveStatus", "suggestionCreatedDate", "qtId", "queryAssignedToGroup", "queryRequestor", "queryResponder", "queryQuestionCategory", "queryQuestionText", "queryAnswer", "queryDetail", "queryAction", "drtId", "duplicateCount", "duplicateList", "duplicateReviewerComment", "duplicateAction", "atId", "topicalAreasRemaining", "topicalAreaHnCounts", "topicalAreasAi", "atIsOrphan", "sentToAttributeReviewBy", "serviceRequestId", "correlationId", "serviceRequestBatchId", "serviceRequestServiceId", "serviceRequestProcessId", "serviceStageIdentifier", "serviceStartTime", "serviceEndTime", "serviceRequestStatusCode", "serviceCreatedDate", "serviceWestLawTime")
AS
  SELECT R1."processContextId",
    R1."processingBatchId",
    R1."clientId",
    R1."clientServer",
    R1."confidenceFactor",
    R1."fileLandingDatetime",
    R1."hierarchyReleaseUuid",
    R1."ingestPath",
    R1."isMetadataIdentified",
    R1."isReconciliationComplete",
    R1."indirectCompletedAtDirect",
    R1."origFileName",
    R1."productBuilderPriority",
    R1."serviceId",
    R1."systemPriority",
    R1."topicNumbers",
    R1."xampexFileName",
    R1."xampexFileLocation",
    R1."requestType",
    R1."requestReceivedTime",
    R1."saId",
    R1."sourceArtifactId",
	R1."deltaTextNotesUuid",
    R1."acquisitionCourtCategory",
    R1."acquisitionCourtId",
    R1."acquisitionProductId",
    R1."acquisitionProductName",
    R1."acquisitionProductType",
    R1."acquisitionProviderLogin",
    R1."acquisitionProviderName",
    R1."rebroadcastReasonCode",
    R1."hasImage",
    R1."hasTable",
    R1."isSupportingDocument",
    R1."pdfUuid",
    R1."pdfUri",
    R1."docketUri",
    R1."westlawLink",
    R1."expertNames",
    R1."pdfUriRoot",
    R1."receiptId",
    R1."receiptDate",
    R1."receiptMethod",
    R1."sourceFileFormat",
    R1."sourceFileName",
    R1."originatingProductType",
    R1."originatingSourceId",
    R1."originatingSourcePdfUuid",
    R1."originatingSourcePdfUri",
    R1."initialLoadTime",
    R1."sourceXmlUuid",
    R1."confidenceFactorQL",
    R1."manuallySourced",
    R1."reasonCode",
    R1.ID                           AS "jaId",
    R1.ARTIFACT_UUID                AS "artifactUuid",
    R1.ARTIFACT_DESCRIPTOR_ID       AS "artifactDescriptorId",
    R1.ARTIFACT_FAMILY_UUID         AS "artifactFamilyUuid",
    R1.ARTIFACT_GROUP_ID            AS "artifactGroupId",
    R1.ARTIFACT_GROUP_DESC          AS "artifactGroupDesc",
    R1.ARTIFACT_PRIORITY            AS "artifactPriority",
    R1.ARTIFACT_PRIORITY_STATUS     AS "artifactPriorityStatus",
    R1.ARTIFACT_SUB_TYPE_ID         AS "artifactSubTypeId",
    R1.ARTIFACT_SUB_TYPE_DESC       AS "artifactSubTypeDesc",
    R1.ARTIFACT_TYPE_ID             AS "artifactTypeId",
    R1.ARTIFACT_TYPE_DESC           AS "artifactTypeDesc",
    R1.CASE_SLUG                    AS "caseSlug",
    R1.CONTENT_SHORT_TITLE          AS "contentShortTitle",
    R1.CONTENT_LONG_TITLE			AS "contentLongTitle",
    R1.FILED_DATE                   AS "filedDate",
    R1.FORMAT                       AS "artifactFormat",
    R1.HEADNOTE_COUNT               AS "headnoteCount",
    R1.JURISDICTION                 AS "jurisdiction",
    R1.LEGACY_ARTIFACT_UUID         AS "legacyArtifactUuid",
    R1.NOVUS_UUID                   AS "novusUuid",
    R1.PAGE_COUNT                   AS "pageCount",
    R1.PRIMARY_DATE                 AS "primaryDate",
    R1.PRODUCT_STAGE                AS "productStage",
    R1.PUBLISHING_FORMAT_NAME       AS "publishingFormatName",
    R1.PUBLISHING_LOCATION          AS "publishingLocation",
    R1.SERIAL_NUMBER                AS "serialNumber",
    R1.VENUE_SHORT_NAME             AS "venueShortName",
    R1.PUB_FORMAT_REASON            AS "pubFormatReason",
    R1.PUB_FORMAT_REASON_UPDATED    AS "pubFormatReasonUpdated",
    R1.ENHANCEMENT_LEVEL            AS "enhancementLevel",
    R1.WESTLAW_CITATION             AS "westlawCitation",
    R1.IS_HOT_ARTIFACT              AS "isHotArtifact",
    R1.IS_RUSH_ARTIFACT             AS "isRushArtifact",
    R1.IS_MARKMAN                   AS "isMarkman",
    R1.IS_BANKRUPTCY                AS "isBankruptcy",
    R1.IS_ED_ENHANCEMENT_REQ        AS "isEdEnhancementRequired",
    R1.IS_IND_HIST_REQ              AS "isIndirectHistoryRequired",
    R1.IS_CONTENT_REVIEW_REQ        AS "isContentReviewRequired",
    R1.IS_REVISOR_REVIEW_REQ        AS "isRevisorReviewRequired",
    R1.HAS_QUERY                    AS "hasQuery",
    R1.HAS_NOTES                    AS "hasNotes",
    R1.PROCESSING_PRIORITY          AS "processingPriority",
    R1.PROCESSING_PRIORITY_OVERRIDE AS "processingPriorityOverride",
	R1.PDF_COMPOSITION_UUID			AS "pdfCompositionUUID",
	R1.OFFICIAL_CITE				AS "officialCite",
	R1.DOCKET_NUMBER				AS "docketNumber",
	R1.LOW_PRIORITY				    AS "lowPriority",
	R1.SUBJECT_GROUP				AS "subjectGroup",
	R1.SUBJECT_SUBGROUP				AS "subjectSubgroup",
	R1.SUBJECT_TYPE					AS "subjectType",
	R1.SPECIALITY_CATEGORY			AS "specialityCategory",
	R1.SPECIALTY_GROUP				AS "specialtyGroup",
    R1.CONFIDENCE_FACTOR_VA         AS "confidenceFactorVA",
    R1.CONFIDENCE_FACTOR_PRINT      AS "confidenceFactorPrint",
    R1.PB_VA_DT_MMR                 AS "pbVaDtMmr",
    R1.PB_PRINT_DT_MMR              AS "pbPrintDtMmr",
    R1.PB_RETRO_DT_MMR              AS "pbRetroDtMmr",
    R1.CONFIDENCE_FACTOR_RETRO      AS "confidenceFactorRetro",
	R1."diId",
	R1."documentUuid",
    R1."docFamilyUuid",
    R1."docketType",
	R1."relationshipReview",
	R1."courtline",
    R1."docketCreatedDate",
    R1."docketReceiptDate",
	R1."docketFiledDate",
    R1."fileLocation", 
    R1."ceId",
    R1."changeEventProcessRef",
    R1."changeEventResourceType",
    R1."changeType",
    R1."eventType",
    R1."changeEventTopicQueue",
    R1."changeEventResourceId",
    R1."changeEventArtifactUuid",
    R1."summaryArtifactUuid",
    R1."changeEventCreatedTime",
    R1."changeEventReceivedTime",
    R1."changeEventProcessedCreated",
    R1."PID",
    R1."processInstanceId",
    R1."processExecutionId",
    R1."processDescription",
    R1."parentProcessInstanceId",
    R1."processDefId",
    R1."processName",
    R1."processType",
    R1."processPathwayLocation",
    R1."processStartTime",
    R1."processEndTime",
    R1."processInitiator",
    R1."processStatus",
    R1."isAsyncProcess",
    R1."isDetachedProcess",
    R1."processCreatedTime",
    R1."tId",
    R1."taskInstanceId",
    R1."parentTaskInstanceId",
    R1."taskDefKey",
    R1."taskExecutionId",
    R1."taskName",
    R1."taskAltName",
    R1."taskAssignee",
    R1."taskClaimTime",
    R1."taskExternalClaim",
    R1."taskCompletedTime",
    R1."taskDue",
    R1."taskCategoryName",
    R1."taskAction",
    R1."taskStatus",
    R1."queryStatus",
    R1."taskCreatedTime",
    R1."abortedBy",
    R1."qualityStatus",
    R1."sentToReviewBy",
    R1."taskInitialLaunchTime",
    R1."userLocation",
	R1."siteResponsible",
    R1."CTID",
    R1."classifier",
    R1."classificationIsActive",
    R1."classificationIsCriminal",
    R1."classificationIteration",
    R1."classificationClaimedBy",
    R1."classificationSummarizer",
    R1."classificationCategoryName",
    R1."classificationTopicData",
    R1."classificationCreatedDate",
    R1."ASTID",
    R1."suggestionId",
    R1."suggestionTerm",
    R1."suggestionComment",
    R1."suggestionAttributeName",
    R1."suggestedBy",
    R1."suggestionActiveStatus",
    R1."suggestionCreatedDate",
    R1."qtId",
    R1."queryAssignedToGroup",
    R1."queryRequestor",
    R1."queryResponder",
    R1."queryQuestionCategory",
    R1."queryQuestionText",
    R1."queryAnswer",
    R1."queryDetail",
    R1."queryAction",
    R1."drtId",
    R1."duplicateCount",
    R1."duplicateList",
    R1."duplicateReviewerComment",
    R1."duplicateAction",
    R1."atId",
    R1."topicalAreasRemaining",
    R1."topicalAreaHnCounts",
    R1."topicalAreasAi",
    R1."atIsOrphan",
	R1."sentToAttributeReviewBy",
    R1."serviceRequestId",
    R1."correlationId",
    R1."serviceRequestBatchId",
    R1."serviceRequestServiceId",
    R1."serviceRequestProcessId",
    R1."serviceStageIdentifier",
    R1."serviceStartTime",
    R1."serviceEndTime",
    R1."serviceRequestStatusCode",
    R1."serviceCreatedDate",
    R1."serviceWestLawTime"
  FROM
    ( SELECT DISTINCT
      -- Process Context
      pc.PROCESS_CONTEXT_ID         AS "processContextId",
      pc.BATCH_ID                   AS "processingBatchId",
      pc.CLIENT_ID                  AS "clientId",
      pc.CLIENT_SERVER              AS "clientServer",
      pc.CONFIDENCE_FACTOR          AS "confidenceFactor",
      pc.FILE_LANDING_DATETIME      AS "fileLandingDatetime",
      pc.HIERARCHY_RELEASE_UUID     AS "hierarchyReleaseUuid",
      pc.INGEST_PATH                AS "ingestPath",
      pc.IS_METADATA_IDENTIFIED     AS "isMetadataIdentified",
      pc.IS_RECONCILIATION_COMPLETE AS "isReconciliationComplete",
      pc.IH_COMP_AT_DH              AS "indirectCompletedAtDirect",
      pc.HAS_QUERY                  AS "hasQuery",
      pc.HAS_NOTES                  AS "hasNotes",
      pc.ORIG_FILE_NAME             AS "origFileName",
      pc.PROCESSING_PRIORITY        AS "processingPriority",
      pc.PRODUCT_BUILDER_PRIORITY "productBuilderPriority",
      pc.SERVICE_ID           AS "serviceId",
      pc.SYSTEM_PRIORITY      AS "systemPriority",
      pc.TOPIC_NUMBERS        AS "topicNumbers",
      pc.XAMPEX_FILE_NAME     AS "xampexFileName",
      pc.XAMPEX_FILE_LOCATION AS "xampexFileLocation",
      pc.REQUEST_TYPE         AS "requestType",
      pc.CREATED_DATE         AS "requestReceivedTime",
      -- Source Artifact
      sa.ID                         AS "saId",
      sa.SOURCE_ARTIFACT_ID         AS "sourceArtifactId",
	  sa.DELTA_TEXT_NOTES_UUID      AS "deltaTextNotesUuid",
      sa.ACQUISITION_COURT_CATEGORY AS "acquisitionCourtCategory",
      sa.ACQUISITION_COURT_ID       AS "acquisitionCourtId",
      sa.ACQUISITION_PRODUCT_ID     AS "acquisitionProductId",
      sa.ACQUISITION_PRODUCT_NAME   AS "acquisitionProductName",
      sa.ACQUISITION_PRODUCT_TYPE   AS "acquisitionProductType",
      sa.ACQUISITION_PROVIDER_LOGIN AS "acquisitionProviderLogin",
      sa.ACQUISITION_PROVIDER_NAME  AS "acquisitionProviderName",
      sa.REBROADCAST_REASON_CODE    AS "rebroadcastReasonCode",
      sa.HAS_IMAGE                  AS "hasImage",
      sa.HAS_TABLE                  AS "hasTable",
      sa.IS_SUPPORTING_DOCUMENT     AS "isSupportingDocument",
      sa.PDF_UUID                   AS "pdfUuid",
      sa.PDF_URI                    AS "pdfUri",
      sa.DOCKET_URI					AS "docketUri",
      sa.WL_LINK					AS "westlawLink",
      sa.EXPERT_NAMES				AS "expertNames",
      sa.PDF_URI_ROOT               AS "pdfUriRoot",
      sa.RECEIPT_ID                 AS "receiptId",
      sa.RECEIPT_DATE               AS "receiptDate",
      sa.RECEIPT_METHOD             AS "receiptMethod",
      sa.SOURCE_FILE_FORMAT         AS "sourceFileFormat",
      sa.SOURCE_FILE_NAME           AS "sourceFileName",
      sa.ORIG_PRODUCT_TYPE          AS "originatingProductType",
      sa.ORIG_SOURCE_ID             AS "originatingSourceId",
      sa.ORIG_SOURCE_PDF_UUID       AS "originatingSourcePdfUuid",
      sa.ORIG_SOURCE_PDF_URI        AS "originatingSourcePdfUri",
      sa.INITIAL_LOAD_TIME       	AS "initialLoadTime",
      sa.SOURCE_XML_UUID        	AS "sourceXmlUuid",
      sa.CONFIDENCE_FACTOR_QL       AS "confidenceFactorQL",      	
	  sa.MANUALLY_SOURCED			AS "manuallySourced",      
      sa.REASON_CODE				AS "reasonCode",
      -- Judicial Artifact
      ja.*,
      --Dockets info
      di.ID						   AS "diId",
	  di.DOCUMENT_UUID             AS "documentUuid",
      di.DOC_FAMILY_UUID           AS "docFamilyUuid",
      di.DOCKET_TYPE               AS "docketType",	 
	  di.RELATIONSHIP_REVIEW	   AS "relationshipReview",
	  di.COURTLINE				   AS "courtline",
	  di.CREATED_DATE              AS "docketCreatedDate",
	  di.RECEIPT_DATE              AS "docketReceiptDate",
      di.FILED_DATE           	   AS "docketFiledDate",
      di.FILE_LOCATION             AS "fileLocation",
      -- Change Event
      ce.CHANGE_EVENT_ID           AS "ceId",
      ce.PROCESS_ID_REF            AS "changeEventProcessRef",
      ce.RESOURCE_TYPE             AS "changeEventResourceType",
      ce.CHANGE_TYPE               AS "changeType",
      ce.EVENT_TYPE                AS "eventType",
      ce.TOPIC                     AS "changeEventTopicQueue",
      ce.RESOURCE_ID               AS "changeEventResourceId",
      ce.ARTIFACT_UUID             AS "changeEventArtifactUuid",
      ce.SUMMARY_ARTIFACT_UUID     AS "summaryArtifactUuid",
      ce.CHANGE_EVENT_CREATED_TIME AS "changeEventCreatedTime",
      ce.RECEIVED_TIME             AS "changeEventReceivedTime",
      ce.PROCESS_CREATED           AS "changeEventProcessedCreated",
      -- Process
      p.ID                         AS pId,
      p.PROCESS_INSTANCE_ID        AS "processInstanceId",
      p.EXECUTION_ID               AS "processExecutionId",
      p.DESCRIPTION                AS "processDescription",
      p.PARENT_PROCESS_INSTANCE_ID AS "parentProcessInstanceId",
      p.PROCESS_DEF_ID             AS "processDefId",
      p.NAME                       AS "processName",
      p.TYPE                       AS "processType",
      p.PATHWAY_LOCATION           AS "processPathwayLocation",
      p.START_TIME                 AS "processStartTime",
      p.END_TIME                   AS "processEndTime",
      p.INITIATOR_ID               AS "processInitiator",
      p.STATUS                     AS "processStatus",
      p.IS_ASYNC                   AS "isAsyncProcess",
      p.IS_DETACHED                AS "isDetachedProcess",
      p.CREATED_DATE               AS "processCreatedTime",
      p.JA_ID                      AS PJA_ID,
      p.SR_ID					   AS sr_id,
      -- Task
      t.ID                      AS "tId",
      t.TASK_INSTANCE_ID        AS "taskInstanceId",
      t.PARENT_TASK_INSTANCE_ID AS "parentTaskInstanceId",
      t.TASK_DEF_KEY            AS "taskDefKey",
      t.EXECUTION_ID            AS "taskExecutionId",
      t.NAME                    AS "taskName",
      t.ALT_NAME                AS "taskAltName",
      t.ASSIGNEE                AS "taskAssignee",
      t.CLAIM_TIME              AS "taskClaimTime",
      t.EXTERNAL_CLAIM          AS "taskExternalClaim",
      t.COMPLETED_TIME          AS "taskCompletedTime",
      t.TASK_DUE                AS "taskDue",
      t.CATEGORY_NAME           AS "taskCategoryName",
      t.TASK_ACTION             AS "taskAction",
      t.STATUS                  AS "taskStatus",
      t.QUERY_STATUS            AS "queryStatus",
      t.CREATED_DATE            AS "taskCreatedTime",
      t.ABORTED_BY              AS "abortedBy",
      t.QUALITY_STATUS          AS "qualityStatus",
      t.SENT_TO_REVIEW_BY       AS "sentToReviewBy",
      t.TASK_INITIAL_LAUNCH		AS "taskInitialLaunchTime",
      t.USER_LOCATION			AS "userLocation",
	  t.SITE_RESPONSIBLE		AS "siteResponsible",
      t.JA_ID                   AS TJA_ID,
      -- classification task
      ct.ID                                    AS ctId,
      ct.CLASSIFIER                            AS "classifier",
      ct.IS_ACTIVE                             AS "classificationIsActive",
      ct.IS_CRIMINAL                           AS "classificationIsCriminal",
      ct.ITERATION                             AS "classificationIteration",
      ct.CLAIMED_BY                            AS "classificationClaimedBy",
      ct.SUMMARIZER                            AS "classificationSummarizer",
      ct.TASK_CATEGORY_NAME                    AS "classificationCategoryName",
      DBMS_LOB.SUBSTR (ct.TOPIC_DATA, 4000, 1) AS "classificationTopicData",
      ct.CREATED_DATE                          AS "classificationCreatedDate",
      -- att suggestion task
      ast.ID 					AS astId,
	  ast.SUGGESTION_ID 		AS "suggestionId",
      ast.SUGGESTION_TERM 		AS "suggestionTerm",
      ast.SUGGESTION_COMMENT 	AS "suggestionComment",
      ast.ATTRIBUTE_NAME 		AS "suggestionAttributeName",
      ast.SUGGESTED_BY 			AS "suggestedBy",
      ast.ACTIVE_STATUS 		AS "suggestionActiveStatus",
      ast.REFRESH_DATE 			AS "suggestionCreatedDate",
      -- query task
      qt.ID                AS "qtId",
      qt.ASSIGNED_TO_GROUP AS "queryAssignedToGroup",
      qt.REQUESTOR         AS "queryRequestor",
      qt.RESPONDER         AS "queryResponder",
      qt.QUESTION_CATEGORY AS "queryQuestionCategory",
      Rtrim(Replace(qt.QUESTION_TEXT , CHR(0), ' '))     AS "queryQuestionText",
      qt.ANSWER            AS "queryAnswer",
      qt.DETAIL            AS "queryDetail",
      qt.ACTION_TO_TAKE    AS "queryAction",
      -- duplicate review task
      drt.ID               AS "drtId",
      drt.DUPE_COUNT       AS "duplicateCount",
      drt.DUPE_LIST        AS "duplicateList",
      drt.REVIEWER_COMMENT AS "duplicateReviewerComment",
      drt.ACTION_TO_TAKE   AS "duplicateAction",
      -- attribute task
      at.ID               			AS "atId",
      at.TOPICAL_AREAS_REMAINING    AS "topicalAreasRemaining",
      at.TOPICAL_AREA_HN_COUNTS    	AS "topicalAreaHnCounts",
      at.TOPICAL_AREAS_AI 			AS "topicalAreasAi",
      at.IS_ORPHAN   				AS "atIsOrphan",
	  at.SENT_TO_ATTRIBUTE_REVIEW_BY	AS "sentToAttributeReviewBy",
      --service request
      sr.ID           AS "serviceRequestId",
      sr.CORRELATION_ID     AS "correlationId",
      sr.BATCH_ID           AS "serviceRequestBatchId",
      sr.SERVICE_ID         AS "serviceRequestServiceId",
      sr.PROCESS_ID         AS "serviceRequestProcessId",
      sr.STAGE_IDENTIFIER   AS "serviceStageIdentifier",
      sr.SERVICE_START_TIME AS "serviceStartTime",
      sr.SERVICE_END_TIME   AS "serviceEndTime",
      sr.STATUS_CODE        AS "serviceRequestStatusCode",
      sr.CREATED_DATE       AS "serviceCreatedDate",
      sr.WESTLAW_TIME       AS "serviceWestLawTime"
    FROM process_context pc
    LEFT JOIN source_artifact sa
    ON pc.process_context_id = sa.process_context_id
    JOIN process p
    ON pc.process_context_id = p.process_context_id
    LEFT JOIN docket_info di
    ON pc.process_context_id = di.process_context_id
    LEFT JOIN change_event ce
    ON pc.process_context_id = ce.process_context_id
    JOIN task t
    ON p.id = t.process_id
    LEFT JOIN judicial_artifact ja
    ON (t.ja_id  = ja.id)
    OR (t.ja_id IS NULL
    AND p.ja_id  = ja.id)
    LEFT JOIN service_request sr
    ON p.sr_id  = sr.id
    LEFT JOIN classification_task ct
    ON t.task_instance_id = ct.task_instance_id
    LEFT JOIN att_suggestion_task ast
    ON t.task_instance_id = ast.task_instance_id
    LEFT JOIN query_task qt
    ON t.task_instance_id = qt.task_instance_id
    LEFT JOIN duplicate_review_task drt
    ON t.task_instance_id                = drt.task_instance_id
    LEFT JOIN attributes_task at
    ON t.task_instance_id                = at.task_instance_id
    WHERE COALESCE(pc.is_archived, 'N') <> 'Y'
    UNION ALL
    SELECT DISTINCT
      -- Process Context
      pc.PROCESS_CONTEXT_ID         AS "processContextId",
      pc.BATCH_ID                   AS "processingBatchId",
      pc.CLIENT_ID                  AS "clientId",
      pc.CLIENT_SERVER              AS "clientServer",
      pc.CONFIDENCE_FACTOR          AS "confidenceFactor",
      pc.FILE_LANDING_DATETIME      AS "fileLandingDatetime",
      pc.HIERARCHY_RELEASE_UUID     AS "hierarchyReleaseUuid",
      pc.INGEST_PATH                AS "ingestPath",
      pc.IS_METADATA_IDENTIFIED     AS "isMetadataIdentified",
      pc.IS_RECONCILIATION_COMPLETE AS "isReconciliationComplete",
      pc.IH_COMP_AT_DH              AS "indirectCompletedAtDirect",
      pc.HAS_QUERY                  AS "hasQuery",
      pc.HAS_NOTES                  AS "hasNotes",
      pc.ORIG_FILE_NAME             AS "origFileName",
      pc.PROCESSING_PRIORITY        AS "processingPriority",
      pc.PRODUCT_BUILDER_PRIORITY "productBuilderPriority",
      pc.SERVICE_ID           AS "serviceId",
      pc.SYSTEM_PRIORITY      AS "systemPriority",
      pc.TOPIC_NUMBERS        AS "topicNumbers",
      pc.XAMPEX_FILE_NAME     AS "xampexFileName",
      pc.XAMPEX_FILE_LOCATION AS "xampexFileLocation",
      pc.REQUEST_TYPE         AS "requestType",
      pc.CREATED_DATE         AS "requestReceivedTime",
      -- Source Artifact
      sa.ID                         AS "saId",
      sa.SOURCE_ARTIFACT_ID         AS "sourceArtifactId",
	  sa.DELTA_TEXT_NOTES_UUID      AS "deltaTextNotesUuid",
      sa.ACQUISITION_COURT_CATEGORY AS "acquisitionCourtCategory",
      sa.ACQUISITION_COURT_ID       AS "acquisitionCourtId",
      sa.ACQUISITION_PRODUCT_ID     AS "acquisitionProductId",
      sa.ACQUISITION_PRODUCT_NAME   AS "acquisitionProductName",
      sa.ACQUISITION_PRODUCT_TYPE   AS "acquisitionProductType",
      sa.ACQUISITION_PROVIDER_LOGIN AS "acquisitionProviderLogin",
      sa.ACQUISITION_PROVIDER_NAME  AS "acquisitionProviderName",
      sa.REBROADCAST_REASON_CODE    AS "rebroadcastReasonCode",
      sa.HAS_IMAGE                  AS "hasImage",
      sa.HAS_TABLE                  AS "hasTable",
      sa.IS_SUPPORTING_DOCUMENT     AS "isSupportingDocument",
      sa.PDF_UUID                   AS "pdfUuid",
      sa.PDF_URI                    AS "pdfUri",
      sa.DOCKET_URI					AS "docketUri",
      sa.WL_LINK					AS "westlawLink",
      sa.EXPERT_NAMES				AS "expertNames",
      sa.PDF_URI_ROOT               AS "pdfUriRoot",
      sa.RECEIPT_ID                 AS "receiptId",
      sa.RECEIPT_DATE               AS "receiptDate",
      sa.RECEIPT_METHOD             AS "receiptMethod",
      sa.SOURCE_FILE_FORMAT         AS "sourceFileFormat",
      sa.SOURCE_FILE_NAME           AS "sourceFileName",
      sa.ORIG_PRODUCT_TYPE          AS "originatingProductType",
      sa.ORIG_SOURCE_ID             AS "originatingSourceId",
      sa.ORIG_SOURCE_PDF_UUID       AS "originatingSourcePdfUuid",
      sa.ORIG_SOURCE_PDF_URI        AS "originatingSourcePdfUri",
      sa.INITIAL_LOAD_TIME       	AS "initialLoadTime",
      sa.SOURCE_XML_UUID        	AS "sourceXmlUuid",
      sa.CONFIDENCE_FACTOR_QL       AS "confidenceFactorQL",      	
	  sa.MANUALLY_SOURCED			AS "manuallySourced",      
      sa.REASON_CODE				AS "reasonCode",
      -- Judicial Artifact
      ja.*,
      --Docket Info
      di.ID						   AS "diId",
	  di.DOCUMENT_UUID             AS "documentUuid",
      di.DOC_FAMILY_UUID           AS "docFamilyUuid",
      di.DOCKET_TYPE               AS "docketType",	 
	  di.RELATIONSHIP_REVIEW	   AS "relationshipReview",
	  di.COURTLINE				   AS "courtline",
	  di.CREATED_DATE              AS "docketCreatedDate",
	  di.RECEIPT_DATE              AS "docketReceiptDate",
      di.FILED_DATE           	   AS "docketFiledDate",
      di.FILE_LOCATION             AS "fileLocation",
      -- Change Event
      ce.CHANGE_EVENT_ID           AS "ceId",
      ce.PROCESS_ID_REF            AS "changeEventProcessRef",
      ce.RESOURCE_TYPE             AS "changeEventResourceType",
      ce.CHANGE_TYPE               AS "changeType",
      ce.EVENT_TYPE                AS "eventType",
      ce.TOPIC                     AS "changeEventTopicQueue",
      ce.RESOURCE_ID               AS "changeEventResourceId",
      ce.ARTIFACT_UUID             AS "changeEventArtifactUuid",
      ce.SUMMARY_ARTIFACT_UUID     AS "summaryArtifactUuid",
      ce.CHANGE_EVENT_CREATED_TIME AS "changeEventCreatedTime",
      ce.RECEIVED_TIME             AS "changeEventReceivedTime",
      ce.PROCESS_CREATED           AS "changeEventProcessedCreated",
      -- Process
      p.ID                         AS pId,
      p.PROCESS_INSTANCE_ID        AS "processInstanceId",
      p.EXECUTION_ID               AS "processExecutionId",
      p.DESCRIPTION                AS "processDescription",
      p.PARENT_PROCESS_INSTANCE_ID AS "parentProcessInstanceId",
      p.PROCESS_DEF_ID             AS "processDefId",
      p.NAME                       AS "processName",
      p.TYPE                       AS "processType",
      p.PATHWAY_LOCATION           AS "processPathwayLocation",
      p.START_TIME                 AS "processStartTime",
      p.END_TIME                   AS "processEndTime",
      p.INITIATOR_ID               AS "processInitiator",
      p.STATUS                     AS "processStatus",
      p.IS_ASYNC                   AS "isAsyncProcess",
      p.IS_DETACHED                AS "isDetachedProcess",
      p.CREATED_DATE               AS "processCreatedTime",
      p.JA_ID                      AS PJA_ID,
      p.SR_ID					   AS sr_id,
      -- Task
      NULL AS "tId",
      NULL AS "taskInstanceId",
      NULL AS "parentTaskInstanceId",
      NULL AS "taskDefKey",
      NULL AS "taskExecutionId",
      NULL AS "taskName",
      NULL AS "taskAltName",
      NULL AS "taskAssignee",
      NULL AS "taskClaimTime",
      NULL AS "taskExternalClaim",
      NULL AS "taskCompletedTime",
      NULL AS "taskDue",
      NULL AS "taskCategoryName",
      NULL AS "taskAction",
      NULL AS "taskStatus",
      NULL AS "queryStatus",
      NULL AS "taskCreatedTime",
      NULL AS "abortedBy",
      NULL AS "qualityStatus",
      NULL AS "sentToReviewBy",
      NULL AS "taskInitialLaunchTime",
      NULL AS "userLocation",
	  NULL AS "siteResponsible",
      NULL AS TJA_ID,
      -- classification task
      NULL AS ctId,
      NULL AS "classifier",
      NULL AS "classificationIsActive",
      NULL AS "classificationIsCriminal",
      NULL AS "classificationIteration",
      NULL AS "classificationClaimedBy",
      NULL AS "classificationSummarizer",
      NULL AS "classificationCategoryName",
      NULL AS "classificationTopicData",
      NULL AS "classificationCreatedDate",     
      -- att suggestion task
      NULL AS astId,
	  NULL AS "suggestionId",
      NULL AS "suggestionTerm",
      NULL AS "suggestionComment",
      NULL AS "suggestionAttributeName",
      NULL AS "suggestedBy",
      NULL AS "suggestionActiveStatus",
      NULL AS "suggestionCreatedDate",
      -- query task
      NULL AS "qtId",
      NULL AS "queryAssignedToGroup",
      NULL AS "queryRequestor",
      NULL AS "queryResponder",
      NULL AS "queryQuestionCategory",
      NULL AS "queryQuestionText",
      NULL AS "queryAnswer",
      NULL AS "queryDetail",
      NULL AS "queryAction",
      -- duplicate review task
      NULL AS "drtId",
      NULL AS "duplicateCount",
      NULL AS "duplicateList",
      NULL AS "duplicateReviewerComment",
      NULL AS "duplicateAction",
      -- attribute task
      NULL AS "atId",
      NULL AS "topicalAreasRemaining",
      NULL AS "topicalAreaHnCounts",
      NULL AS "topicalAreasAi",
      NULL AS "atIsOrphan",
	  NULL AS "sentToAttributeReviewBy",
        --service request
      sr.ID           AS "serviceRequestId",
      sr.CORRELATION_ID     AS "correlationId",
      sr.BATCH_ID           AS "serviceRequestBatchId",
      sr.SERVICE_ID         AS "serviceRequestServiceId",
      sr.PROCESS_ID         AS "serviceRequestProcessId",
      sr.STAGE_IDENTIFIER   AS "serviceStageIdentifier",
      sr.SERVICE_START_TIME AS "serviceStartTime",
      sr.SERVICE_END_TIME   AS "serviceEndTime",
      sr.STATUS_CODE        AS "serviceRequestStatusCode",
      sr.CREATED_DATE       AS "serviceCreatedDate",
      sr.WESTLAW_TIME       AS "serviceWestLawTime"
    FROM process_context pc
    JOIN process p
    ON pc.process_context_id = p.process_context_id
    LEFT JOIN judicial_artifact ja
    ON p.ja_id = ja.id
    LEFT JOIN service_request sr
    ON p.sr_id = sr.id
    LEFT JOIN source_artifact sa
    ON pc.process_context_id = sa.process_context_id
    LEFT JOIN docket_info di
    ON pc.process_context_id = di.process_context_id
    LEFT JOIN change_event ce
    ON pc.process_context_id             = ce.process_context_id
    WHERE COALESCE(pc.is_archived, 'N') <> 'Y'
    ) R1;
  /
  
  CREATE OR REPLACE SYNONYM JDGWORKFLOW_USER.V_GLOBAL_SEARCH_NEW FOR JDGWORKFLOWAPP.V_GLOBAL_SEARCH_NEW;
  GRANT
  SELECT ON JDGWORKFLOWAPP.V_GLOBAL_SEARCH_NEW TO JDGWORKFLOW_USER;
  /
  
  CREATE OR REPLACE FORCE VIEW JDGWORKFLOWAPP.V_INSTANCE_DATA_ISSUE ("processContextId", "processingBatchId", "clientId", "clientServer", "confidenceFactor", "fileLandingDatetime", "hierarchyReleaseUuid", "ingestPath", "isMetadataIdentified", "isReconciliationComplete", "indirectCompletedAtDirect", "origFileName", "productBuilderPriority", "serviceId", "systemPriority", "topicNumbers", "xampexFileName", "xampexFileLocation", "requestType", "requestReceivedTime", "saId", "sourceArtifactId","deltaTextNotesUuid", "acquisitionCourtCategory", "acquisitionCourtId", "acquisitionProductId", "acquisitionProductName", "acquisitionProductType", "acquisitionProviderLogin", "acquisitionProviderName","rebroadcastReasonCode", "hasImage", "hasTable", "isSupportingDocument", "pdfUuid", "pdfUri", "docketUri", "westlawLink", "expertNames", "pdfUriRoot", "receiptId", "receiptDate", "receiptMethod", "sourceFileFormat", "sourceFileName", "originatingProductType", "originatingSourceId", "originatingSourcePdfUuid", "originatingSourcePdfUri", "initialLoadTime", "sourceXmlUuid", "confidenceFactorQL", "manuallySourced", "reasonCode", "jaId", "artifactUuid", "artifactDescriptorId", "artifactFamilyUuid",
  "artifactGroupId", "artifactGroupDesc", "artifactPriority", "artifactPriorityStatus", "artifactSubTypeId", "artifactSubTypeDesc", "artifactTypeId", "artifactTypeDesc", "caseSlug", "contentShortTitle", "contentLongTitle", "filedDate", "artifactFormat", "headnoteCount", "jurisdiction", "legacyArtifactUuid", "novusUuid", "pageCount", "primaryDate", "productStage", "publishingFormatName", "publishingLocation", "serialNumber", "venueShortName", "pubFormatReason", "pubFormatReasonUpdated", "enhancementLevel", "westlawCitation", "isHotArtifact", "isRushArtifact", "isMarkman", "isBankruptcy", "isEdEnhancementRequired", "isIndirectHistoryRequired", "isContentReviewRequired", "isRevisorReviewRequired", "hasQuery", "hasNotes", "processingPriority", "processingPriorityOverride", "pdfCompositionUUID", "officialCite", "docketNumber", "lowPriority", "subjectGroup", "subjectSubgroup", "subjectType", "specialityCategory", "specialtyGroup", "confidenceFactorVA", "confidenceFactorPrint", "pbVaDtMmr", "pbPrintDtMmr","pbRetroDtMmr","confidenceFactorRetro", "diId", "documentUuid", "docFamilyUuid", "docketType", "relationshipReview", "courtline", "docketCreatedDate", "docketReceiptDate", "docketFiledDate", "fileLocation", "ceId", "changeEventProcessRef", "changeEventResourceType", "changeType", "eventType", "changeEventTopicQueue", "changeEventResourceId", "changeEventArtifactUuid", "summaryArtifactUuid", "changeEventCreatedTime", "changeEventReceivedTime", "changeEventProcessedCreated", "PID",
  "processInstanceId", "processExecutionId", "processDescription", "parentProcessInstanceId", "processDefId", "processName", "processType", "processPathwayLocation", "processStartTime", "processEndTime", "processInitiator", "processStatus", "isAsyncProcess", "isDetachedProcess", "processCreatedTime", "tId", "taskInstanceId", "parentTaskInstanceId", "taskDefKey", "taskExecutionId", "taskName", "taskAltName", "taskAssignee", "taskClaimTime", "taskExternalClaim", "taskCompletedTime", "taskDue", "taskCategoryName", "taskAction", "taskStatus", "queryStatus", "taskCreatedTime", "abortedBy", "qualityStatus", "sentToReviewBy", "taskInitialLaunchTime", "userLocation", "siteResponsible", "CTID", "classifier", "classificationIsActive", "classificationIsCriminal", "classificationIteration", "classificationClaimedBy", "classificationSummarizer", "classificationCategoryName", "classificationTopicData", "classificationCreatedDate", 
  "astId", "suggestionId", "suggestionTerm", "suggestionComment", "suggestionAttributeName", "suggestedBy", "suggestionActiveStatus", "suggestionCreatedDate", "qtId", "queryAssignedToGroup", "queryRequestor", "queryResponder", "queryQuestionCategory", "queryQuestionText", "queryAnswer", "queryDetail", "queryAction", "drtId", "duplicateCount", "duplicateList", "duplicateReviewerComment", "duplicateAction", "atId", "topicalAreasRemaining", "topicalAreaHnCounts", "topicalAreasAi", "atIsOrphan", "sentToAttributeReviewBy", "issueId", "issueTaskInstanceId", "issueServiceId", "issueCode", "issueCategory", "issueText", "serviceRequestId", "correlationId", "serviceRequestBatchId", "serviceRequestServiceId", "serviceRequestProcessId", "serviceStageIdentifier", "serviceStartTime", "serviceEndTime", "serviceRequestStatusCode", "serviceCreatedDate", "serviceWestLawTime")
AS
  SELECT R1."processContextId",
    R1."processingBatchId",
    R1."clientId",
    R1."clientServer",
    R1."confidenceFactor",
    R1."fileLandingDatetime",
    R1."hierarchyReleaseUuid",
    R1."ingestPath",
    R1."isMetadataIdentified",
    R1."isReconciliationComplete",
    R1."indirectCompletedAtDirect",
    --R1."hasQuery",R1."hasNotes",R1."origFileName",R1."processingPriority",
    R1."origFileName",
    R1."productBuilderPriority",
    R1."serviceId",
    R1."systemPriority",
    R1."topicNumbers",
    R1."xampexFileName",
    R1."xampexFileLocation",
    R1."requestType",
    R1."requestReceivedTime",
    R1."saId",
    R1."sourceArtifactId",
	R1."deltaTextNotesUuid",
    R1."acquisitionCourtCategory",
    R1."acquisitionCourtId",
    R1."acquisitionProductId",
    R1."acquisitionProductName",
    R1."acquisitionProductType",
    R1."acquisitionProviderLogin",
    R1."acquisitionProviderName",
    R1."rebroadcastReasonCode",
    R1."hasImage",
    R1."hasTable",
    R1."isSupportingDocument",
    R1."pdfUuid",
    R1."pdfUri",
    R1."docketUri",
    R1."westlawLink",
    R1."expertNames",
    R1."pdfUriRoot",
    R1."receiptId",
    R1."receiptDate",
    R1."receiptMethod",
    R1."sourceFileFormat",
    R1."sourceFileName",
    R1."originatingProductType",
    R1."originatingSourceId",
    R1."originatingSourcePdfUuid",
    R1."originatingSourcePdfUri",
    R1."initialLoadTime",
    R1."sourceXmlUuid",
    R1."confidenceFactorQL",
    R1."manuallySourced",
    R1."reasonCode",
    --R1."jaId",R1."artifactUuid",R1."artifactDescriptorId",R1."artifactFamilyUuid",R1."artifactGroupId",R1."artifactGroupDesc",R1."artifactPriority",R1."artifactPriorityStatus",R1."artifactSubTypeId",R1."artifactSubTypeDesc",R1."artifactTypeId",R1."artifactTypeDesc",R1."caseSlug",R1."contentShortTitle",R1."filedDate",R1."artifactFormat",R1."headnoteCount",R1."jurisdiction",R1."legacyArtifactUuid",R1."pageCount",R1."primaryDate",R1."productStage",R1."publishingFormatName",R1."publishingLocation",R1."serialNumber",R1."venueShortName",R1."pubFormatReason", R1."pubFormatReasonUpdated", R1."enhancementLevel",R1."westlawCitation",R1."isHotArtifact",R1."isRushArtifact",R1."isMarkman",R1."isBankruptcy",R1."isEdEnhancementRequired",R1."isIndirectHistoryRequired",R1."isContentReviewRequired",R1."isRevisorReviewRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.TJA_ID
      ELSE PJA.ID
    END) AS "jaId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_UUID
      ELSE PJA.ARTIFACT_UUID
    END) AS "artifactUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_DESCRIPTOR_ID
      ELSE PJA.ARTIFACT_DESCRIPTOR_ID
    END) AS "artifactDescriptorId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_FAMILY_UUID
      ELSE PJA.ARTIFACT_FAMILY_UUID
    END) AS "artifactFamilyUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_GROUP_ID
      ELSE PJA.ARTIFACT_GROUP_ID
    END) AS "artifactGroupId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_GROUP_DESC
      ELSE PJA.ARTIFACT_GROUP_DESC
    END) AS "artifactGroupDesc",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_PRIORITY
      ELSE PJA.ARTIFACT_PRIORITY
    END) AS "artifactPriority",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_PRIORITY_STATUS
      ELSE PJA.ARTIFACT_PRIORITY_STATUS
    END) AS "artifactPriorityStatus",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_SUB_TYPE_ID
      ELSE PJA.ARTIFACT_SUB_TYPE_ID
    END) AS "artifactSubTypeId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_SUB_TYPE_DESC
      ELSE PJA.ARTIFACT_SUB_TYPE_DESC
    END) AS "artifactSubTypeDesc",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_TYPE_ID
      ELSE PJA.ARTIFACT_TYPE_ID
    END) AS "artifactTypeId",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ARTIFACT_TYPE_DESC
      ELSE PJA.ARTIFACT_TYPE_DESC
    END) AS "artifactTypeDesc",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CASE_SLUG
      ELSE PJA.CASE_SLUG
    END) AS "caseSlug",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONTENT_SHORT_TITLE
      ELSE PJA.CONTENT_SHORT_TITLE
    END) AS "contentShortTitle",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONTENT_LONG_TITLE
      ELSE PJA.CONTENT_LONG_TITLE
    END) AS "contentLongTitle",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.FILED_DATE
      ELSE PJA.FILED_DATE
    END) AS "filedDate",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.FORMAT
      ELSE PJA.FORMAT
    END) AS "artifactFormat",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.HEADNOTE_COUNT
      ELSE PJA.HEADNOTE_COUNT
    END) AS "headnoteCount",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.JURISDICTION
      ELSE PJA.JURISDICTION
    END) AS "jurisdiction",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.LEGACY_ARTIFACT_UUID
      ELSE PJA.LEGACY_ARTIFACT_UUID
    END) AS "legacyArtifactUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.NOVUS_UUID
      ELSE PJA.NOVUS_UUID
    END) AS "novusUuid",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PAGE_COUNT
      ELSE PJA.PAGE_COUNT
    END) AS "pageCount",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PRIMARY_DATE
      ELSE PJA.PRIMARY_DATE
    END) AS "primaryDate",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PRODUCT_STAGE
      ELSE PJA.PRODUCT_STAGE
    END) AS "productStage",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PUBLISHING_FORMAT_NAME
      ELSE PJA.PUBLISHING_FORMAT_NAME
    END) AS "publishingFormatName",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PUBLISHING_LOCATION
      ELSE PJA.PUBLISHING_LOCATION
    END) AS "publishingLocation",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SERIAL_NUMBER
      ELSE PJA.SERIAL_NUMBER
    END) AS "serialNumber",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.VENUE_SHORT_NAME
      ELSE PJA.VENUE_SHORT_NAME
    END) AS "venueShortName",
    (
	CASE
	   WHEN R1.TJA_ID IS NOT NULL
	   THEN R1.PUB_FORMAT_REASON
	   ELSE PJA.PUB_FORMAT_REASON
	END) AS "pubFormatReason",
	(CASE
	   WHEN R1.TJA_ID IS NOT NULL
	   THEN R1.PUB_FORMAT_REASON_UPDATED
	   ELSE PJA.PUB_FORMAT_REASON_UPDATED
	END) AS "pubFormatReasonUpdated",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.ENHANCEMENT_LEVEL
      ELSE PJA.ENHANCEMENT_LEVEL
    END) AS "enhancementLevel",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.WESTLAW_CITATION
      ELSE PJA.WESTLAW_CITATION
    END) AS "westlawCitation",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_HOT_ARTIFACT
      ELSE PJA.IS_HOT_ARTIFACT
    END) AS "isHotArtifact",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_RUSH_ARTIFACT
      ELSE PJA.IS_RUSH_ARTIFACT
    END) AS "isRushArtifact",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_MARKMAN
      ELSE PJA.IS_MARKMAN
    END) AS "isMarkman",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_BANKRUPTCY
      ELSE PJA.IS_BANKRUPTCY
    END) AS "isBankruptcy",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_ED_ENHANCEMENT_REQ
      ELSE PJA.IS_ED_ENHANCEMENT_REQ
    END) AS "isEdEnhancementRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_IND_HIST_REQ
      ELSE PJA.IS_IND_HIST_REQ
    END) AS "isIndirectHistoryRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_CONTENT_REVIEW_REQ
      ELSE PJA.IS_CONTENT_REVIEW_REQ
    END) AS "isContentReviewRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.IS_REVISOR_REVIEW_REQ
      ELSE PJA.IS_REVISOR_REVIEW_REQ
    END) AS "isRevisorReviewRequired",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.HAS_QUERY
      ELSE PJA.HAS_QUERY
    END) AS "hasQuery",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.HAS_NOTES
      ELSE PJA.HAS_NOTES
    END) AS "hasNotes",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PROCESSING_PRIORITY
      ELSE PJA.PROCESSING_PRIORITY
    END) AS "processingPriority",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PROCESSING_PRIORITY_OVERRIDE
      ELSE PJA.PROCESSING_PRIORITY
    END) AS "processingPriorityOverride",
	(
	CASE
      WHEN R1.TJA_ID IS NOT NULL
	  THEN R1.PDF_COMPOSITION_UUID
	  ELSE PJA.PDF_COMPOSITION_UUID		
	END) AS "pdfCompositionUUID",
	(
	CASE
      WHEN R1.TJA_ID IS NOT NULL
	  THEN R1.OFFICIAL_CITE
	  ELSE PJA.OFFICIAL_CITE		
	END) AS "officialCite",
	(
	CASE
      WHEN R1.TJA_ID IS NOT NULL
	  THEN R1.DOCKET_NUMBER
	  ELSE PJA.DOCKET_NUMBER		
	END) AS "docketNumber",
	(
	CASE
      WHEN R1.TJA_ID IS NOT NULL
	  THEN R1.LOW_PRIORITY
	  ELSE PJA.LOW_PRIORITY		
	END) AS "lowPriority",
	(
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SUBJECT_GROUP
      ELSE PJA.SUBJECT_GROUP
    END) AS "subjectGroup",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SUBJECT_SUBGROUP
      ELSE PJA.SUBJECT_SUBGROUP
    END) AS "subjectSubgroup",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SUBJECT_TYPE
      ELSE PJA.SUBJECT_TYPE
    END) AS "subjectType",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SPECIALITY_CATEGORY
      ELSE PJA.SPECIALITY_CATEGORY
    END) AS "specialityCategory",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.SPECIALTY_GROUP
      ELSE PJA.SPECIALTY_GROUP
    END) AS "specialtyGroup",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONFIDENCE_FACTOR_VA
      ELSE PJA.CONFIDENCE_FACTOR_VA
    END) AS "confidenceFactorVA",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONFIDENCE_FACTOR_PRINT
      ELSE PJA.CONFIDENCE_FACTOR_PRINT
    END) AS "confidenceFactorPrint",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PB_VA_DT_MMR
      ELSE PJA.PB_VA_DT_MMR
    END) AS "pbVaDtMmr",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PB_PRINT_DT_MMR
      ELSE PJA.PB_PRINT_DT_MMR
    END) AS "pbPrintDtMmr",
    (
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.PB_RETRO_DT_MMR
      ELSE PJA.PB_RETRO_DT_MMR
    END) AS "pbRetroDtMmr",
	(
    CASE
      WHEN R1.TJA_ID IS NOT NULL
      THEN R1.CONFIDENCE_FACTOR_RETRO
      ELSE PJA.CONFIDENCE_FACTOR_RETRO
    END) AS "confidenceFactorRetro",
	R1."diId",
	R1."documentUuid",
    R1."docFamilyUuid",
    R1."docketType",
	R1."relationshipReview",
	R1."courtline",
    R1."docketCreatedDate",
    R1."docketReceiptDate",
	R1."docketFiledDate",
    R1."fileLocation",
    R1."ceId",
    R1."changeEventProcessRef",
    R1."changeEventResourceType",
    R1."changeType",
    R1."eventType",
    R1."changeEventTopicQueue",
    R1."changeEventResourceId",
    R1."changeEventArtifactUuid",
    R1."summaryArtifactUuid",
    R1."changeEventCreatedTime",
    R1."changeEventReceivedTime",
    R1."changeEventProcessedCreated",
    R1."PID",
    R1."processInstanceId",
    R1."processExecutionId",
    R1."processDescription",
    R1."parentProcessInstanceId",
    R1."processDefId",
    R1."processName",
    R1."processType",
    R1."processPathwayLocation",
    R1."processStartTime",
    R1."processEndTime",
    R1."processInitiator",
    R1."processStatus",
    R1."isAsyncProcess",
    R1."isDetachedProcess",
    R1."processCreatedTime",
    R1."tId",
    R1."taskInstanceId",
    R1."parentTaskInstanceId",
    R1."taskDefKey",
    R1."taskExecutionId",
    R1."taskName",
    R1."taskAltName",
    R1."taskAssignee",
    R1."taskClaimTime",
    R1."taskExternalClaim",
    R1."taskCompletedTime",
    R1."taskDue",
    R1."taskCategoryName",
    R1."taskAction",
    R1."taskStatus",
    R1."queryStatus",
    R1."taskCreatedTime",
    R1."abortedBy",
    R1."qualityStatus",
    R1."sentToReviewBy",
    R1."taskInitialLaunchTime",
    R1."userLocation",
	R1."siteResponsible",
    R1."CTID",
    R1."classifier",
    R1."classificationIsActive",
    R1."classificationIsCriminal",
    R1."classificationIteration",
    R1."classificationClaimedBy",
    R1."classificationSummarizer",
    R1."classificationCategoryName",
    R1."classificationTopicData",
    R1."classificationCreatedDate",
    R1."ASTID",
    R1."suggestionId",
    R1."suggestionTerm",
    R1."suggestionComment",
    R1."suggestionAttributeName",
    R1."suggestedBy",
    R1."suggestionActiveStatus",
    R1."suggestionCreatedDate",
    R1."qtId",
    R1."queryAssignedToGroup",
    R1."queryRequestor",
    R1."queryResponder",
    R1."queryQuestionCategory",
    R1."queryQuestionText",
    R1."queryAnswer",
    R1."queryDetail",
    R1."queryAction",
    R1."drtId",
    R1."duplicateCount",
    R1."duplicateList",
    R1."duplicateReviewerComment",
    R1."duplicateAction",
    R1."atId",
    R1."topicalAreasRemaining",
    R1."topicalAreaHnCounts",
    R1."topicalAreasAi",
    R1."atIsOrphan",
	R1."sentToAttributeReviewBy",
    R1."issueId",
    R1."issueTaskInstanceId",
    R1."issueServiceId",
    R1."issueCode",
    R1."issueCategory",
    R1."issueText",
    R1."serviceRequestId",
    R1."correlationId",
    R1."serviceRequestBatchId",
    R1."serviceRequestServiceId",
    R1."serviceRequestProcessId",
    R1."serviceStageIdentifier",
    R1."serviceStartTime",
    R1."serviceEndTime",
    R1."serviceRequestStatusCode",
    R1."serviceCreatedDate",
    R1."serviceWestLawTime"
  FROM
    ( SELECT DISTINCT
      -- Process Context
      pc.PROCESS_CONTEXT_ID         AS "processContextId",
      pc.BATCH_ID                   AS "processingBatchId",
      pc.CLIENT_ID                  AS "clientId",
      pc.CLIENT_SERVER              AS "clientServer",
      pc.CONFIDENCE_FACTOR          AS "confidenceFactor",
      pc.FILE_LANDING_DATETIME      AS "fileLandingDatetime",
      pc.HIERARCHY_RELEASE_UUID     AS "hierarchyReleaseUuid",
      pc.INGEST_PATH                AS "ingestPath",
      pc.IS_METADATA_IDENTIFIED     AS "isMetadataIdentified",
      pc.IS_RECONCILIATION_COMPLETE AS "isReconciliationComplete",
      pc.IH_COMP_AT_DH              AS "indirectCompletedAtDirect",
      --          pc.HAS_QUERY AS "hasQuery",
      --          pc.HAS_NOTES AS "hasNotes",
      pc.ORIG_FILE_NAME AS "origFileName",
      --          pc.PROCESSING_PRIORITY AS "processingPriority",
      pc.PRODUCT_BUILDER_PRIORITY "productBuilderPriority",
      pc.SERVICE_ID           AS "serviceId",
      pc.SYSTEM_PRIORITY      AS "systemPriority",
      pc.TOPIC_NUMBERS        AS "topicNumbers",
      pc.XAMPEX_FILE_NAME     AS "xampexFileName",
      pc.XAMPEX_FILE_LOCATION AS "xampexFileLocation",
      pc.REQUEST_TYPE         AS "requestType",
      pc.CREATED_DATE         AS "requestReceivedTime",
      -- Source Artifact
      sa.ID                         AS "saId",
      sa.SOURCE_ARTIFACT_ID         AS "sourceArtifactId",
	  sa.DELTA_TEXT_NOTES_UUID      AS "deltaTextNotesUuid",
      sa.ACQUISITION_COURT_CATEGORY AS "acquisitionCourtCategory",
      sa.ACQUISITION_COURT_ID       AS "acquisitionCourtId",
      sa.ACQUISITION_PRODUCT_ID     AS "acquisitionProductId",
      sa.ACQUISITION_PRODUCT_NAME   AS "acquisitionProductName",
      sa.ACQUISITION_PRODUCT_TYPE   AS "acquisitionProductType",
      sa.ACQUISITION_PROVIDER_LOGIN AS "acquisitionProviderLogin",
      sa.ACQUISITION_PROVIDER_NAME  AS "acquisitionProviderName",
      sa.REBROADCAST_REASON_CODE    AS "rebroadcastReasonCode",
      sa.HAS_IMAGE                  AS "hasImage",
      sa.HAS_TABLE                  AS "hasTable",
      sa.IS_SUPPORTING_DOCUMENT     AS "isSupportingDocument",
      sa.PDF_UUID                   AS "pdfUuid",
      sa.PDF_URI                    AS "pdfUri",
      sa.DOCKET_URI					AS "docketUri",
      sa.WL_LINK					AS "westlawLink",
      sa.EXPERT_NAMES				AS "expertNames",
      sa.PDF_URI_ROOT               AS "pdfUriRoot",
      sa.RECEIPT_ID                 AS "receiptId",
      sa.RECEIPT_DATE               AS "receiptDate",
      sa.RECEIPT_METHOD             AS "receiptMethod",
      sa.SOURCE_FILE_FORMAT         AS "sourceFileFormat",
      sa.SOURCE_FILE_NAME           AS "sourceFileName",
      sa.ORIG_PRODUCT_TYPE          AS "originatingProductType",
      sa.ORIG_SOURCE_ID             AS "originatingSourceId",
      sa.ORIG_SOURCE_PDF_UUID       AS "originatingSourcePdfUuid",
      sa.ORIG_SOURCE_PDF_URI        AS "originatingSourcePdfUri",
      sa.INITIAL_LOAD_TIME       	AS "initialLoadTime",
      sa.SOURCE_XML_UUID        	AS "sourceXmlUuid",
      sa.CONFIDENCE_FACTOR_QL       AS "confidenceFactorQL",
	  sa.MANUALLY_SOURCED			AS "manuallySourced",      
      sa.REASON_CODE				AS "reasonCode",
      -- Judicial Artifact
      ja.*,
      --Docket Info
      di.ID						   AS "diId",
	  di.DOCUMENT_UUID             AS "documentUuid",
      di.DOC_FAMILY_UUID           AS "docFamilyUuid",
      di.DOCKET_TYPE               AS "docketType",	 
	  di.RELATIONSHIP_REVIEW	   AS "relationshipReview",
	  di.COURTLINE				   AS "courtline",
	  di.CREATED_DATE              AS "docketCreatedDate",
	  di.RECEIPT_DATE              AS "docketReceiptDate",
      di.FILED_DATE           	   AS "docketFiledDate",
      di.FILE_LOCATION             AS "fileLocation",      
      -- Change Event
      ce.CHANGE_EVENT_ID           AS "ceId",
      ce.PROCESS_ID_REF            AS "changeEventProcessRef",
      ce.RESOURCE_TYPE             AS "changeEventResourceType",
      ce.CHANGE_TYPE               AS "changeType",
      ce.EVENT_TYPE                AS "eventType",
      ce.TOPIC                     AS "changeEventTopicQueue",
      ce.RESOURCE_ID               AS "changeEventResourceId",
      ce.ARTIFACT_UUID             AS "changeEventArtifactUuid",
      ce.SUMMARY_ARTIFACT_UUID     AS "summaryArtifactUuid",
      ce.CHANGE_EVENT_CREATED_TIME AS "changeEventCreatedTime",
      ce.RECEIVED_TIME             AS "changeEventReceivedTime",
      ce.PROCESS_CREATED           AS "changeEventProcessedCreated",
      -- Process
      p.ID                         AS pId,
      p.PROCESS_INSTANCE_ID        AS "processInstanceId",
      p.EXECUTION_ID               AS "processExecutionId",
      p.DESCRIPTION                AS "processDescription",
      p.PARENT_PROCESS_INSTANCE_ID AS "parentProcessInstanceId",
      p.PROCESS_DEF_ID             AS "processDefId",
      p.NAME                       AS "processName",
      p.TYPE                       AS "processType",
      p.PATHWAY_LOCATION           AS "processPathwayLocation",
      p.START_TIME                 AS "processStartTime",
      p.END_TIME                   AS "processEndTime",
      p.INITIATOR_ID               AS "processInitiator",
      p.STATUS                     AS "processStatus",
      p.IS_ASYNC                   AS "isAsyncProcess",
      p.IS_DETACHED                AS "isDetachedProcess",
      p.CREATED_DATE               AS "processCreatedTime",
      p.JA_ID                      AS PJA_ID,
      p.SR_ID					   AS sr_id,
      -- Task
      t.ID                      AS "tId",
      t.TASK_INSTANCE_ID        AS "taskInstanceId",
      t.PARENT_TASK_INSTANCE_ID AS "parentTaskInstanceId",
      t.TASK_DEF_KEY            AS "taskDefKey",
      t.EXECUTION_ID            AS "taskExecutionId",
      t.NAME                    AS "taskName",
      t.ALT_NAME                AS "taskAltName",
      t.ASSIGNEE                AS "taskAssignee",
      t.CLAIM_TIME              AS "taskClaimTime",
      t.EXTERNAL_CLAIM          AS "taskExternalClaim",
      t.COMPLETED_TIME          AS "taskCompletedTime",
      t.TASK_DUE                AS "taskDue",
      t.CATEGORY_NAME           AS "taskCategoryName",
      t.TASK_ACTION             AS "taskAction",
      t.STATUS                  AS "taskStatus",
      t.QUERY_STATUS            AS "queryStatus",
      t.CREATED_DATE            AS "taskCreatedTime",
      t.ABORTED_BY              AS "abortedBy",
      t.QUALITY_STATUS          AS "qualityStatus",
      t.SENT_TO_REVIEW_BY       AS "sentToReviewBy",
      t.TASK_INITIAL_LAUNCH		AS "taskInitialLaunchTime",
      t.USER_LOCATION			AS "userLocation",
	  t.SITE_RESPONSIBLE 		AS "siteResponsible",
      t.JA_ID                   AS TJA_ID,
      -- classification task
      ct.ID                                    AS ctId,
      ct.CLASSIFIER                            AS "classifier",
      ct.IS_ACTIVE                             AS "classificationIsActive",
      ct.IS_CRIMINAL                           AS "classificationIsCriminal",
      ct.ITERATION                             AS "classificationIteration",
      ct.CLAIMED_BY                            AS "classificationClaimedBy",
      ct.SUMMARIZER                            AS "classificationSummarizer",
      ct.TASK_CATEGORY_NAME                    AS "classificationCategoryName",
      DBMS_LOB.SUBSTR (ct.TOPIC_DATA, 4000, 1) AS "classificationTopicData",
      ct.CREATED_DATE                          AS "classificationCreatedDate",
      -- att suggestion task
      ast.ID 					AS astId,
	  ast.SUGGESTION_ID 		AS "suggestionId",
      ast.SUGGESTION_TERM 		AS "suggestionTerm",
      ast.SUGGESTION_COMMENT 	AS "suggestionComment",
      ast.ATTRIBUTE_NAME 		AS "suggestionAttributeName",
      ast.SUGGESTED_BY 			AS "suggestedBy",
      ast.ACTIVE_STATUS 		AS "suggestionActiveStatus",
      ast.REFRESH_DATE 			AS "suggestionCreatedDate",
      -- query task
      qt.ID                AS "qtId",
      qt.ASSIGNED_TO_GROUP AS "queryAssignedToGroup",
      qt.REQUESTOR         AS "queryRequestor",
      qt.RESPONDER         AS "queryResponder",
      qt.QUESTION_CATEGORY AS "queryQuestionCategory",
      Rtrim(Replace(qt.QUESTION_TEXT , CHR(0), ' '))     AS "queryQuestionText",
      qt.ANSWER            AS "queryAnswer",
      qt.DETAIL            AS "queryDetail",
      qt.ACTION_TO_TAKE    AS "queryAction",
      -- duplicate review task
      drt.ID               AS "drtId",
      drt.DUPE_COUNT       AS "duplicateCount",
      drt.DUPE_LIST        AS "duplicateList",
      drt.REVIEWER_COMMENT AS "duplicateReviewerComment",
      drt.ACTION_TO_TAKE   AS "duplicateAction",
      -- attribute task
      at.ID               			AS "atId",
      at.TOPICAL_AREAS_REMAINING    AS "topicalAreasRemaining",
      at.TOPICAL_AREA_HN_COUNTS    	AS "topicalAreaHnCounts",
      at.TOPICAL_AREAS_AI 			AS "topicalAreasAi",
      at.IS_ORPHAN   				AS "atIsOrphan",
	  at.SENT_TO_ATTRIBUTE_REVIEW_BY	AS "sentToAttributeReviewBy",
       --issue
      iss.ISSUE_ID              AS "issueId",
      iss.TASK_INSTANCE_ID      AS "issueTaskInstanceId",
      iss.SERVICE_ID            AS "issueServiceId",
      iss.ISSUE_CODE            AS "issueCode",
      iss.ISSUE_CATEGORY        AS "issueCategory",
      DBMS_LOB.SUBSTR (iss.ISSUE_TEXT, 4000, 1) AS "issueText",
      --service request
      sr.ID           AS "serviceRequestId",
      sr.CORRELATION_ID     AS "correlationId",
      sr.BATCH_ID           AS "serviceRequestBatchId",
      sr.SERVICE_ID         AS "serviceRequestServiceId",
      sr.PROCESS_ID         AS "serviceRequestProcessId",
      sr.STAGE_IDENTIFIER   AS "serviceStageIdentifier",
      sr.SERVICE_START_TIME AS "serviceStartTime",
      sr.SERVICE_END_TIME   AS "serviceEndTime",
      sr.STATUS_CODE        AS "serviceRequestStatusCode",
      sr.CREATED_DATE       AS "serviceCreatedDate",
      sr.WESTLAW_TIME       AS "serviceWestLawTime"
    FROM process_context pc,
      judicial_artifact ja,
      source_artifact sa,
      process p,
      docket_info di,
      change_event ce,
      task t,
      classification_task ct,
      att_suggestion_task ast,
      query_task qt,
      duplicate_review_task drt,
      attributes_task at,
      issue iss,
      service_request sr
    WHERE pc.process_context_id        = p.process_context_id
    AND t.ja_id                        = ja.id(+)
    AND pc.process_context_id          = sa.process_context_id(+)
    AND pc.process_context_id          = di.process_context_id(+)
    AND pc.process_context_id          = ce.process_context_id(+)
    AND p.id                           = t.process_id
    AND p.sr_id						   = sr.id(+)
    AND t.task_instance_id             = ct.task_instance_id(+)
    AND t.task_instance_id             = ast.task_instance_id(+)
    AND t.task_instance_id             = qt.task_instance_id(+)
    AND t.task_instance_id             = iss.task_instance_id(+)
    AND t.task_instance_id             = drt.task_instance_id(+)
    AND t.task_instance_id             = at.task_instance_id(+)
    AND COALESCE(pc.is_archived, 'N') <> 'Y'
    ) R1,
    judicial_artifact pja
  WHERE R1.pja_id                = pja.id(+);
  /
  
  CREATE OR REPLACE SYNONYM JDGWORKFLOW_USER.V_INSTANCE_DATA_ISSUE FOR JDGWORKFLOWAPP.V_INSTANCE_DATA_ISSUE;
  GRANT
  SELECT ON JDGWORKFLOWAPP.V_INSTANCE_DATA_ISSUE TO JDGWORKFLOW_USER;
  /
  
  CREATE OR REPLACE FORCE VIEW JDGWORKFLOWAPP.V_GLOBAL_SEARCH_ISSUE ("processContextId", "processingBatchId", "clientId", "clientServer", "confidenceFactor", "fileLandingDatetime", "hierarchyReleaseUuid", "ingestPath", "isMetadataIdentified", "isReconciliationComplete", "indirectCompletedAtDirect", "origFileName", "productBuilderPriority", "serviceId", "systemPriority", "topicNumbers", "xampexFileName", "xampexFileLocation", "requestType", "requestReceivedTime", "saId", "sourceArtifactId", "deltaTextNotesUuid","acquisitionCourtCategory", "acquisitionCourtId", "acquisitionProductId", "acquisitionProductName", "acquisitionProductType", "acquisitionProviderLogin", "acquisitionProviderName","rebroadcastReasonCode", "hasImage", "hasTable", "isSupportingDocument", "pdfUuid", "pdfUri", "docketUri", "westlawLink","expertNames", "pdfUriRoot", "receiptId", "receiptDate", "receiptMethod", "sourceFileFormat", "sourceFileName", "originatingProductType", "originatingSourceId", "originatingSourcePdfUuid", "originatingSourcePdfUri", "initialLoadTime", "sourceXmlUuid", "confidenceFactorQL", "manuallySourced", "reasonCode", "jaId", "artifactUuid", "artifactDescriptorId", "artifactFamilyUuid",
  "artifactGroupId", "artifactGroupDesc", "artifactPriority", "artifactPriorityStatus", "artifactSubTypeId", "artifactSubTypeDesc", "artifactTypeId", "artifactTypeDesc", "caseSlug", "contentShortTitle", "contentLongTitle", "filedDate", "artifactFormat", "headnoteCount", "jurisdiction", "legacyArtifactUuid", "novusUuid", "pageCount", "primaryDate", "productStage", "publishingFormatName", "publishingLocation", "serialNumber", "venueShortName", "pubFormatReason", "pubFormatReasonUpdated", "enhancementLevel", "westlawCitation", "isHotArtifact", "isRushArtifact", "isMarkman", "isBankruptcy", "isEdEnhancementRequired", "isIndirectHistoryRequired", "isContentReviewRequired", "isRevisorReviewRequired", "hasQuery", "hasNotes", "processingPriority", "processingPriorityOverride", "pdfCompositionUUID", "officialCite", "docketNumber","lowPriority", "subjectGroup", "subjectSubgroup", "subjectType", "specialityCategory", "specialtyGroup", "confidenceFactorVA", "confidenceFactorPrint", "pbVaDtMmr", "pbPrintDtMmr","pbRetroDtMmr","confidenceFactorRetro","diId", "documentUuid", "docFamilyUuid", "docketType", "relationshipReview", "courtline", "docketCreatedDate", "docketReceiptDate", "docketFiledDate", "fileLocation", "ceId", "changeEventProcessRef", "changeEventResourceType", "changeType", "eventType", "changeEventTopicQueue", "changeEventResourceId", "changeEventArtifactUuid", "summaryArtifactUuid", "changeEventCreatedTime", "changeEventReceivedTime", "changeEventProcessedCreated", "PID",
  "processInstanceId", "processExecutionId", "processDescription", "parentProcessInstanceId", "processDefId", "processName", "processType", "processPathwayLocation", "processStartTime", "processEndTime", "processInitiator", "processStatus", "isAsyncProcess", "isDetachedProcess", "processCreatedTime", "tId", "taskInstanceId", "parentTaskInstanceId", "taskDefKey", "taskExecutionId", "taskName", "taskAltName", "taskAssignee", "taskClaimTime", "taskExternalClaim", "taskCompletedTime", "taskDue", "taskCategoryName", "taskAction", "taskStatus", "queryStatus", "taskCreatedTime", "abortedBy", "qualityStatus", "sentToReviewBy", "taskInitialLaunchTime", "userLocation", "siteResponsible", "CTID", "classifier", "classificationIsActive", "classificationIsCriminal", "classificationIteration", "classificationClaimedBy", "classificationSummarizer", "classificationCategoryName", "classificationTopicData", "classificationCreatedDate", 
  "astId", "suggestionId", "suggestionTerm", "suggestionComment", "suggestionAttributeName", "suggestedBy", "suggestionActiveStatus", "suggestionCreatedDate", "qtId", "queryAssignedToGroup", "queryRequestor", "queryResponder", "queryQuestionCategory", "queryQuestionText", "queryAnswer", "queryDetail", "queryAction", "drtId", "duplicateCount", "duplicateList", "duplicateReviewerComment", "duplicateAction", "atId", "topicalAreasRemaining", "topicalAreaHnCounts", "topicalAreasAi", "atIsOrphan", "sentToAttributeReviewBy", "issueId", "issueTaskInstanceId", "issueServiceId", "issueCode", "issueCategory", "issueText", "serviceRequestId", "correlationId", "serviceRequestBatchId", "serviceRequestServiceId", "serviceRequestProcessId", "serviceStageIdentifier", "serviceStartTime", "serviceEndTime", "serviceRequestStatusCode", "serviceCreatedDate", "serviceWestLawTime")
AS
  SELECT R1."processContextId",
    R1."processingBatchId",
    R1."clientId",
    R1."clientServer",
    R1."confidenceFactor",
    R1."fileLandingDatetime",
    R1."hierarchyReleaseUuid",
    R1."ingestPath",
    R1."isMetadataIdentified",
    R1."isReconciliationComplete",
    R1."indirectCompletedAtDirect",
    R1."origFileName",
    R1."productBuilderPriority",
    R1."serviceId",
    R1."systemPriority",
    R1."topicNumbers",
    R1."xampexFileName",
    R1."xampexFileLocation",
    R1."requestType",
    R1."requestReceivedTime",
    R1."saId",
    R1."sourceArtifactId",
	R1."deltaTextNotesUuid",
    R1."acquisitionCourtCategory",
    R1."acquisitionCourtId",
    R1."acquisitionProductId",
    R1."acquisitionProductName",
    R1."acquisitionProductType",
    R1."acquisitionProviderLogin",
    R1."acquisitionProviderName",
    R1."rebroadcastReasonCode",
    R1."hasImage",
    R1."hasTable",
    R1."isSupportingDocument",
    R1."pdfUuid",
    R1."pdfUri",
    R1."docketUri",
    R1."westlawLink",
    R1."expertNames",
    R1."pdfUriRoot",
    R1."receiptId",
    R1."receiptDate",
    R1."receiptMethod",
    R1."sourceFileFormat",
    R1."sourceFileName",
    R1."originatingProductType",
    R1."originatingSourceId",
    R1."originatingSourcePdfUuid",
    R1."originatingSourcePdfUri",
    R1."initialLoadTime",
    R1."sourceXmlUuid",
    R1."confidenceFactorQL",
    R1."manuallySourced",
    R1."reasonCode",    
    R1.ID                           AS "jaId",
    R1.ARTIFACT_UUID                AS "artifactUuid",
    R1.ARTIFACT_DESCRIPTOR_ID       AS "artifactDescriptorId",
    R1.ARTIFACT_FAMILY_UUID         AS "artifactFamilyUuid",
    R1.ARTIFACT_GROUP_ID            AS "artifactGroupId",
    R1.ARTIFACT_GROUP_DESC          AS "artifactGroupDesc",
    R1.ARTIFACT_PRIORITY            AS "artifactPriority",
    R1.ARTIFACT_PRIORITY_STATUS     AS "artifactPriorityStatus",
    R1.ARTIFACT_SUB_TYPE_ID         AS "artifactSubTypeId",
    R1.ARTIFACT_SUB_TYPE_DESC       AS "artifactSubTypeDesc",
    R1.ARTIFACT_TYPE_ID             AS "artifactTypeId",
    R1.ARTIFACT_TYPE_DESC           AS "artifactTypeDesc",
    R1.CASE_SLUG                    AS "caseSlug",
    R1.CONTENT_SHORT_TITLE          AS "contentShortTitle",
    R1.CONTENT_LONG_TITLE			AS "contentLongTitle",
    R1.FILED_DATE                   AS "filedDate",
    R1.FORMAT                       AS "artifactFormat",
    R1.HEADNOTE_COUNT               AS "headnoteCount",
    R1.JURISDICTION                 AS "jurisdiction",
    R1.LEGACY_ARTIFACT_UUID         AS "legacyArtifactUuid",
    R1.NOVUS_UUID                   AS "novusUuid",
    R1.PAGE_COUNT                   AS "pageCount",
    R1.PRIMARY_DATE                 AS "primaryDate",
    R1.PRODUCT_STAGE                AS "productStage",
    R1.PUBLISHING_FORMAT_NAME       AS "publishingFormatName",
    R1.PUBLISHING_LOCATION          AS "publishingLocation",
    R1.SERIAL_NUMBER                AS "serialNumber",
    R1.VENUE_SHORT_NAME             AS "venueShortName",
    R1.PUB_FORMAT_REASON            AS "pubFormatReason",
    R1.PUB_FORMAT_REASON_UPDATED    AS "pubFormatReasonUpdated",
    R1.ENHANCEMENT_LEVEL            AS "enhancementLevel",
    R1.WESTLAW_CITATION             AS "westlawCitation",
    R1.IS_HOT_ARTIFACT              AS "isHotArtifact",
    R1.IS_RUSH_ARTIFACT             AS "isRushArtifact",
    R1.IS_MARKMAN                   AS "isMarkman",
    R1.IS_BANKRUPTCY                AS "isBankruptcy",
    R1.IS_ED_ENHANCEMENT_REQ        AS "isEdEnhancementRequired",
    R1.IS_IND_HIST_REQ              AS "isIndirectHistoryRequired",
    R1.IS_CONTENT_REVIEW_REQ        AS "isContentReviewRequired",
    R1.IS_REVISOR_REVIEW_REQ        AS "isRevisorReviewRequired",
    R1.HAS_QUERY                    AS "hasQuery",
    R1.HAS_NOTES                    AS "hasNotes",
    R1.PROCESSING_PRIORITY          AS "processingPriority",
    R1.PROCESSING_PRIORITY_OVERRIDE AS "processingPriorityOverride",
	R1.PDF_COMPOSITION_UUID			AS "pdfCompositionUUID",
	R1.OFFICIAL_CITE				AS "officialCite",
	R1.DOCKET_NUMBER				AS "docketNumber",
	R1.LOW_PRIORITY				    AS "lowPriority",
	R1.SUBJECT_GROUP				AS "subjectGroup",
	R1.SUBJECT_SUBGROUP				AS "subjectSubgroup",
	R1.SUBJECT_TYPE					AS "subjectType",
	R1.SPECIALITY_CATEGORY			AS "specialityCategory",
	R1.SPECIALTY_GROUP				AS "specialtyGroup",
    R1.CONFIDENCE_FACTOR_VA         AS "confidenceFactorVA",
    R1.CONFIDENCE_FACTOR_PRINT      AS "confidenceFactorPrint",
    R1.PB_VA_DT_MMR                 AS "pbVaDtMmr",
    R1.PB_PRINT_DT_MMR              AS "pbPrintDtMmr",
    R1.PB_RETRO_DT_MMR              AS "pbRetroDtMmr",
    R1.CONFIDENCE_FACTOR_RETRO      AS "confidenceFactorRetro",
	R1."diId",
	R1."documentUuid",
    R1."docFamilyUuid",
    R1."docketType",
	R1."relationshipReview",
	R1."courtline",
    R1."docketCreatedDate",
    R1."docketReceiptDate",
	R1."docketFiledDate",
    R1."fileLocation", 
    R1."ceId",
    R1."changeEventProcessRef",
    R1."changeEventResourceType",
    R1."changeType",
    R1."eventType",
    R1."changeEventTopicQueue",
    R1."changeEventResourceId",
    R1."changeEventArtifactUuid",
    R1."summaryArtifactUuid",
    R1."changeEventCreatedTime",
    R1."changeEventReceivedTime",
    R1."changeEventProcessedCreated",
    R1."PID",
    R1."processInstanceId",
    R1."processExecutionId",
    R1."processDescription",
    R1."parentProcessInstanceId",
    R1."processDefId",
    R1."processName",
    R1."processType",
    R1."processPathwayLocation",
    R1."processStartTime",
    R1."processEndTime",
    R1."processInitiator",
    R1."processStatus",
    R1."isAsyncProcess",
    R1."isDetachedProcess",
    R1."processCreatedTime",
    R1."tId",
    R1."taskInstanceId",
    R1."parentTaskInstanceId",
    R1."taskDefKey",
    R1."taskExecutionId",
    R1."taskName",
    R1."taskAltName",
    R1."taskAssignee",
    R1."taskClaimTime",
    R1."taskExternalClaim",
    R1."taskCompletedTime",
    R1."taskDue",
    R1."taskCategoryName",
    R1."taskAction",
    R1."taskStatus",
    R1."queryStatus",
    R1."taskCreatedTime",
    R1."abortedBy",
    R1."qualityStatus",
    R1."sentToReviewBy",
    R1."taskInitialLaunchTime",
    R1."userLocation",
	R1."siteResponsible",
    R1."CTID",
    R1."classifier",
    R1."classificationIsActive",
    R1."classificationIsCriminal",
    R1."classificationIteration",
    R1."classificationClaimedBy",
    R1."classificationSummarizer",
    R1."classificationCategoryName",
    R1."classificationTopicData",
    R1."classificationCreatedDate",
    R1."ASTID",
    R1."suggestionId",
    R1."suggestionTerm",
    R1."suggestionComment",
    R1."suggestionAttributeName",
    R1."suggestedBy",
    R1."suggestionActiveStatus",
    R1."suggestionCreatedDate",
    R1."qtId",
    R1."queryAssignedToGroup",
    R1."queryRequestor",
    R1."queryResponder",
    R1."queryQuestionCategory",
    R1."queryQuestionText",
    R1."queryAnswer",
    R1."queryDetail",
    R1."queryAction",
    R1."drtId",
    R1."duplicateCount",
    R1."duplicateList",
    R1."duplicateReviewerComment",
    R1."duplicateAction",
    R1."atId",
    R1."topicalAreasRemaining",
    R1."topicalAreaHnCounts",
    R1."topicalAreasAi",
    R1."atIsOrphan",
	R1."sentToAttributeReviewBy",
    R1."issueId",
    R1."issueTaskInstanceId",
    R1."issueServiceId",
    R1."issueCode",
    R1."issueCategory",
    R1."issueText",
    R1."serviceRequestId",
    R1."correlationId",
    R1."serviceRequestBatchId",
    R1."serviceRequestServiceId",
    R1."serviceRequestProcessId",
    R1."serviceStageIdentifier",
    R1."serviceStartTime",
    R1."serviceEndTime",
    R1."serviceRequestStatusCode",
    R1."serviceCreatedDate",
    R1."serviceWestLawTime"
  FROM
    ( SELECT DISTINCT
      -- Process Context
      pc.PROCESS_CONTEXT_ID         AS "processContextId",
      pc.BATCH_ID                   AS "processingBatchId",
      pc.CLIENT_ID                  AS "clientId",
      pc.CLIENT_SERVER              AS "clientServer",
      pc.CONFIDENCE_FACTOR          AS "confidenceFactor",
      pc.FILE_LANDING_DATETIME      AS "fileLandingDatetime",
      pc.HIERARCHY_RELEASE_UUID     AS "hierarchyReleaseUuid",
      pc.INGEST_PATH                AS "ingestPath",
      pc.IS_METADATA_IDENTIFIED     AS "isMetadataIdentified",
      pc.IS_RECONCILIATION_COMPLETE AS "isReconciliationComplete",
      pc.IH_COMP_AT_DH              AS "indirectCompletedAtDirect",
      pc.HAS_QUERY                  AS "hasQuery",
      pc.HAS_NOTES                  AS "hasNotes",
      pc.ORIG_FILE_NAME             AS "origFileName",
      pc.PROCESSING_PRIORITY        AS "processingPriority",
      pc.PRODUCT_BUILDER_PRIORITY "productBuilderPriority",
      pc.SERVICE_ID           AS "serviceId",
      pc.SYSTEM_PRIORITY      AS "systemPriority",
      pc.TOPIC_NUMBERS        AS "topicNumbers",
      pc.XAMPEX_FILE_NAME     AS "xampexFileName",
      pc.XAMPEX_FILE_LOCATION AS "xampexFileLocation",
      pc.REQUEST_TYPE         AS "requestType",
      pc.CREATED_DATE         AS "requestReceivedTime",
      -- Source Artifact
      sa.ID                         AS "saId",
      sa.SOURCE_ARTIFACT_ID         AS "sourceArtifactId",
	  sa.DELTA_TEXT_NOTES_UUID      AS "deltaTextNotesUuid",
      sa.ACQUISITION_COURT_CATEGORY AS "acquisitionCourtCategory",
      sa.ACQUISITION_COURT_ID       AS "acquisitionCourtId",
      sa.ACQUISITION_PRODUCT_ID     AS "acquisitionProductId",
      sa.ACQUISITION_PRODUCT_NAME   AS "acquisitionProductName",
      sa.ACQUISITION_PRODUCT_TYPE   AS "acquisitionProductType",
      sa.ACQUISITION_PROVIDER_LOGIN AS "acquisitionProviderLogin",
      sa.ACQUISITION_PROVIDER_NAME  AS "acquisitionProviderName",
      sa.REBROADCAST_REASON_CODE    AS "rebroadcastReasonCode",
      sa.HAS_IMAGE                  AS "hasImage",
      sa.HAS_TABLE                  AS "hasTable",
      sa.IS_SUPPORTING_DOCUMENT     AS "isSupportingDocument",
      sa.PDF_UUID                   AS "pdfUuid",
      sa.PDF_URI                    AS "pdfUri",
      sa.DOCKET_URI					AS "docketUri",
      sa.WL_LINK					AS "westlawLink",
      sa.EXPERT_NAMES				AS "expertNames",
      sa.PDF_URI_ROOT               AS "pdfUriRoot",
      sa.RECEIPT_ID                 AS "receiptId",
      sa.RECEIPT_DATE               AS "receiptDate",
      sa.RECEIPT_METHOD             AS "receiptMethod",
      sa.SOURCE_FILE_FORMAT         AS "sourceFileFormat",
      sa.SOURCE_FILE_NAME           AS "sourceFileName",
      sa.ORIG_PRODUCT_TYPE          AS "originatingProductType",
      sa.ORIG_SOURCE_ID             AS "originatingSourceId",
      sa.ORIG_SOURCE_PDF_UUID       AS "originatingSourcePdfUuid",
      sa.ORIG_SOURCE_PDF_URI        AS "originatingSourcePdfUri",
      sa.INITIAL_LOAD_TIME       	AS "initialLoadTime",
      sa.SOURCE_XML_UUID        	AS "sourceXmlUuid",
      sa.CONFIDENCE_FACTOR_QL       AS "confidenceFactorQL",
	  sa.MANUALLY_SOURCED			AS "manuallySourced",      
      sa.REASON_CODE				AS "reasonCode",      
      -- Judicial Artifact
      ja.*,
      --Docket Info
      di.ID						   AS "diId",
	  di.DOCUMENT_UUID             AS "documentUuid",
      di.DOC_FAMILY_UUID           AS "docFamilyUuid",
      di.DOCKET_TYPE               AS "docketType",	 
	  di.RELATIONSHIP_REVIEW	   AS "relationshipReview",
	  di.COURTLINE				   AS "courtline",
	  di.CREATED_DATE              AS "docketCreatedDate",
	  di.RECEIPT_DATE              AS "docketReceiptDate",
      di.FILED_DATE           	   AS "docketFiledDate",
      di.FILE_LOCATION             AS "fileLocation",
      -- Change Event
      ce.CHANGE_EVENT_ID           AS "ceId",
      ce.PROCESS_ID_REF            AS "changeEventProcessRef",
      ce.RESOURCE_TYPE             AS "changeEventResourceType",
      ce.CHANGE_TYPE               AS "changeType",
      ce.EVENT_TYPE                AS "eventType",
      ce.TOPIC                     AS "changeEventTopicQueue",
      ce.RESOURCE_ID               AS "changeEventResourceId",
      ce.ARTIFACT_UUID             AS "changeEventArtifactUuid",
      ce.SUMMARY_ARTIFACT_UUID     AS "summaryArtifactUuid",
      ce.CHANGE_EVENT_CREATED_TIME AS "changeEventCreatedTime",
      ce.RECEIVED_TIME             AS "changeEventReceivedTime",
      ce.PROCESS_CREATED           AS "changeEventProcessedCreated",
      -- Process
      p.ID                         AS pId,
      p.PROCESS_INSTANCE_ID        AS "processInstanceId",
      p.EXECUTION_ID               AS "processExecutionId",
      p.DESCRIPTION                AS "processDescription",
      p.PARENT_PROCESS_INSTANCE_ID AS "parentProcessInstanceId",
      p.PROCESS_DEF_ID             AS "processDefId",
      p.NAME                       AS "processName",
      p.TYPE                       AS "processType",
      p.PATHWAY_LOCATION           AS "processPathwayLocation",
      p.START_TIME                 AS "processStartTime",
      p.END_TIME                   AS "processEndTime",
      p.INITIATOR_ID               AS "processInitiator",
      p.STATUS                     AS "processStatus",
      p.IS_ASYNC                   AS "isAsyncProcess",
      p.IS_DETACHED                AS "isDetachedProcess",
      p.CREATED_DATE               AS "processCreatedTime",
      p.JA_ID                      AS PJA_ID,
      p.SR_ID					   AS sr_id,
      -- Task
      t.ID                      AS "tId",
      t.TASK_INSTANCE_ID        AS "taskInstanceId",
      t.PARENT_TASK_INSTANCE_ID AS "parentTaskInstanceId",
      t.TASK_DEF_KEY            AS "taskDefKey",
      t.EXECUTION_ID            AS "taskExecutionId",
      t.NAME                    AS "taskName",
      t.ALT_NAME                AS "taskAltName",
      t.ASSIGNEE                AS "taskAssignee",
      t.CLAIM_TIME              AS "taskClaimTime",
      t.EXTERNAL_CLAIM          AS "taskExternalClaim",
      t.COMPLETED_TIME          AS "taskCompletedTime",
      t.TASK_DUE                AS "taskDue",
      t.CATEGORY_NAME           AS "taskCategoryName",
      t.TASK_ACTION             AS "taskAction",
      t.STATUS                  AS "taskStatus",
      t.QUERY_STATUS            AS "queryStatus",
      t.CREATED_DATE            AS "taskCreatedTime",
      t.ABORTED_BY              AS "abortedBy",
      t.QUALITY_STATUS          AS "qualityStatus",
      t.SENT_TO_REVIEW_BY       AS "sentToReviewBy",
      t.TASK_INITIAL_LAUNCH		AS "taskInitialLaunchTime",
      t.USER_LOCATION			AS "userLocation",
	  t.SITE_RESPONSIBLE		AS "siteResponsible",
      t.JA_ID                   AS TJA_ID,
      -- classification task
      ct.ID                                    AS ctId,
      ct.CLASSIFIER                            AS "classifier",
      ct.IS_ACTIVE                             AS "classificationIsActive",
      ct.IS_CRIMINAL                           AS "classificationIsCriminal",
      ct.ITERATION                             AS "classificationIteration",
      ct.CLAIMED_BY                            AS "classificationClaimedBy",
      ct.SUMMARIZER                            AS "classificationSummarizer",
      ct.TASK_CATEGORY_NAME                    AS "classificationCategoryName",
      DBMS_LOB.SUBSTR (ct.TOPIC_DATA, 4000, 1) AS "classificationTopicData",
      ct.CREATED_DATE                          AS "classificationCreatedDate",
      -- att suggestion task
      ast.ID 					AS astId,
	  ast.SUGGESTION_ID 		AS "suggestionId",
      ast.SUGGESTION_TERM 		AS "suggestionTerm",
      ast.SUGGESTION_COMMENT 	AS "suggestionComment",
      ast.ATTRIBUTE_NAME 		AS "suggestionAttributeName",
      ast.SUGGESTED_BY 			AS "suggestedBy",
      ast.ACTIVE_STATUS 		AS "suggestionActiveStatus",
      ast.REFRESH_DATE 			AS "suggestionCreatedDate",
      -- query task
      qt.ID                AS "qtId",
      qt.ASSIGNED_TO_GROUP AS "queryAssignedToGroup",
      qt.REQUESTOR         AS "queryRequestor",
      qt.RESPONDER         AS "queryResponder",
      qt.QUESTION_CATEGORY AS "queryQuestionCategory",
      Rtrim(Replace(qt.QUESTION_TEXT , CHR(0), ' '))     AS "queryQuestionText",
      qt.ANSWER            AS "queryAnswer",
      qt.DETAIL            AS "queryDetail",
      qt.ACTION_TO_TAKE    AS "queryAction",
      -- duplicate review task
      drt.ID               AS "drtId",
      drt.DUPE_COUNT       AS "duplicateCount",
      drt.DUPE_LIST        AS "duplicateList",
      drt.REVIEWER_COMMENT AS "duplicateReviewerComment",
      drt.ACTION_TO_TAKE   AS "duplicateAction",
      -- attribute task
      at.ID               			AS "atId",
      at.TOPICAL_AREAS_REMAINING    AS "topicalAreasRemaining",
      at.TOPICAL_AREA_HN_COUNTS    	AS "topicalAreaHnCounts",
      at.TOPICAL_AREAS_AI 			AS "topicalAreasAi",
      at.IS_ORPHAN   				AS "atIsOrphan",
	  at.SENT_TO_ATTRIBUTE_REVIEW_BY	AS "sentToAttributeReviewBy",
      --issue
      iss.ISSUE_ID              AS "issueId",
      iss.TASK_INSTANCE_ID      AS "issueTaskInstanceId",
      iss.SERVICE_ID            AS "issueServiceId",
      iss.ISSUE_CODE            AS "issueCode",
      iss.ISSUE_CATEGORY        AS "issueCategory",
      DBMS_LOB.SUBSTR (iss.ISSUE_TEXT, 4000, 1) AS "issueText",
      --service request
      sr.ID           AS "serviceRequestId",
      sr.CORRELATION_ID     AS "correlationId",
      sr.BATCH_ID           AS "serviceRequestBatchId",
      sr.SERVICE_ID         AS "serviceRequestServiceId",
      sr.PROCESS_ID         AS "serviceRequestProcessId",
      sr.STAGE_IDENTIFIER   AS "serviceStageIdentifier",
      sr.SERVICE_START_TIME AS "serviceStartTime",
      sr.SERVICE_END_TIME   AS "serviceEndTime",
      sr.STATUS_CODE        AS "serviceRequestStatusCode",
      sr.CREATED_DATE       AS "serviceCreatedDate",
      sr.WESTLAW_TIME       AS "serviceWestLawTime"
    FROM process_context pc
    LEFT JOIN source_artifact sa
    ON pc.process_context_id = sa.process_context_id
    JOIN process p
    ON pc.process_context_id = p.process_context_id
    LEFT JOIN docket_info di
    ON pc.process_context_id = di.process_context_id
    LEFT JOIN change_event ce
    ON pc.process_context_id = ce.process_context_id
    JOIN task t
    ON p.id = t.process_id
    LEFT JOIN judicial_artifact ja
    ON (t.ja_id  = ja.id)
    OR (t.ja_id IS NULL
    AND p.ja_id  = ja.id)
    LEFT JOIN service_request sr
    ON p.sr_id  = sr.id
    LEFT JOIN classification_task ct
    ON t.task_instance_id = ct.task_instance_id
    LEFT JOIN att_suggestion_task ast
    ON t.task_instance_id = ast.task_instance_id
    LEFT JOIN issue iss
    ON t.task_instance_id = iss.task_instance_id
    LEFT JOIN query_task qt
    ON t.task_instance_id = qt.task_instance_id
    LEFT JOIN duplicate_review_task drt
    ON t.task_instance_id                = drt.task_instance_id
    LEFT JOIN attributes_task at
    ON t.task_instance_id                = at.task_instance_id
    WHERE COALESCE(pc.is_archived, 'N') <> 'Y'
    UNION ALL
    SELECT DISTINCT
      -- Process Context
      pc.PROCESS_CONTEXT_ID         AS "processContextId",
      pc.BATCH_ID                   AS "processingBatchId",
      pc.CLIENT_ID                  AS "clientId",
      pc.CLIENT_SERVER              AS "clientServer",
      pc.CONFIDENCE_FACTOR          AS "confidenceFactor",
      pc.FILE_LANDING_DATETIME      AS "fileLandingDatetime",
      pc.HIERARCHY_RELEASE_UUID     AS "hierarchyReleaseUuid",
      pc.INGEST_PATH                AS "ingestPath",
      pc.IS_METADATA_IDENTIFIED     AS "isMetadataIdentified",
      pc.IS_RECONCILIATION_COMPLETE AS "isReconciliationComplete",
      pc.IH_COMP_AT_DH              AS "indirectCompletedAtDirect",
      pc.HAS_QUERY                  AS "hasQuery",
      pc.HAS_NOTES                  AS "hasNotes",
      pc.ORIG_FILE_NAME             AS "origFileName",
      pc.PROCESSING_PRIORITY        AS "processingPriority",
      pc.PRODUCT_BUILDER_PRIORITY "productBuilderPriority",
      pc.SERVICE_ID           AS "serviceId",
      pc.SYSTEM_PRIORITY      AS "systemPriority",
      pc.TOPIC_NUMBERS        AS "topicNumbers",
      pc.XAMPEX_FILE_NAME     AS "xampexFileName",
      pc.XAMPEX_FILE_LOCATION AS "xampexFileLocation",
      pc.REQUEST_TYPE         AS "requestType",
      pc.CREATED_DATE         AS "requestReceivedTime",
      -- Source Artifact
      sa.ID                         AS "saId",
      sa.SOURCE_ARTIFACT_ID         AS "sourceArtifactId",
	  sa.DELTA_TEXT_NOTES_UUID      AS "deltaTextNotesUuid",
      sa.ACQUISITION_COURT_CATEGORY AS "acquisitionCourtCategory",
      sa.ACQUISITION_COURT_ID       AS "acquisitionCourtId",
      sa.ACQUISITION_PRODUCT_ID     AS "acquisitionProductId",
      sa.ACQUISITION_PRODUCT_NAME   AS "acquisitionProductName",
      sa.ACQUISITION_PRODUCT_TYPE   AS "acquisitionProductType",
      sa.ACQUISITION_PROVIDER_LOGIN AS "acquisitionProviderLogin",
      sa.ACQUISITION_PROVIDER_NAME  AS "acquisitionProviderName",
      sa.REBROADCAST_REASON_CODE    AS "rebroadcastReasonCode",
      sa.HAS_IMAGE                  AS "hasImage",
      sa.HAS_TABLE                  AS "hasTable",
      sa.IS_SUPPORTING_DOCUMENT     AS "isSupportingDocument",
      sa.PDF_UUID                   AS "pdfUuid",
      sa.PDF_URI                    AS "pdfUri",
      sa.DOCKET_URI					AS "docketUri",
      sa.WL_LINK					AS "westlawLink",
      sa.EXPERT_NAMES				AS "expertNames",
      sa.PDF_URI_ROOT               AS "pdfUriRoot",
      sa.RECEIPT_ID                 AS "receiptId",
      sa.RECEIPT_DATE               AS "receiptDate",
      sa.RECEIPT_METHOD             AS "receiptMethod",
      sa.SOURCE_FILE_FORMAT         AS "sourceFileFormat",
      sa.SOURCE_FILE_NAME           AS "sourceFileName",
      sa.ORIG_PRODUCT_TYPE          AS "originatingProductType",
      sa.ORIG_SOURCE_ID             AS "originatingSourceId",
      sa.ORIG_SOURCE_PDF_UUID       AS "originatingSourcePdfUuid",
      sa.ORIG_SOURCE_PDF_URI        AS "originatingSourcePdfUri",
      sa.INITIAL_LOAD_TIME       	AS "initialLoadTime",
      sa.SOURCE_XML_UUID        	AS "sourceXmlUuid",
      sa.CONFIDENCE_FACTOR_QL       AS "confidenceFactorQL",
      sa.MANUALLY_SOURCED			AS "manuallySourced",      
      sa.REASON_CODE				AS "reasonCode",
      -- Judicial Artifact
      ja.*,
      --Docket Info
      di.ID						   AS "diId",
	  di.DOCUMENT_UUID             AS "documentUuid",
      di.DOC_FAMILY_UUID           AS "docFamilyUuid",
      di.DOCKET_TYPE               AS "docketType",	 
	  di.RELATIONSHIP_REVIEW	   AS "relationshipReview",
	  di.COURTLINE				   AS "courtline",
	  di.CREATED_DATE              AS "docketCreatedDate",
	  di.RECEIPT_DATE              AS "docketReceiptDate",
      di.FILED_DATE           	   AS "docketFiledDate",
      di.FILE_LOCATION             AS "fileLocation",
      -- Change Event
      ce.CHANGE_EVENT_ID           AS "ceId",
      ce.PROCESS_ID_REF            AS "changeEventProcessRef",
      ce.RESOURCE_TYPE             AS "changeEventResourceType",
      ce.CHANGE_TYPE               AS "changeType",
      ce.EVENT_TYPE                AS "eventType",
      ce.TOPIC                     AS "changeEventTopicQueue",
      ce.RESOURCE_ID               AS "changeEventResourceId",
      ce.ARTIFACT_UUID             AS "changeEventArtifactUuid",
      ce.SUMMARY_ARTIFACT_UUID     AS "summaryArtifactUuid",
      ce.CHANGE_EVENT_CREATED_TIME AS "changeEventCreatedTime",
      ce.RECEIVED_TIME             AS "changeEventReceivedTime",
      ce.PROCESS_CREATED           AS "changeEventProcessedCreated",
      -- Process
      p.ID                         AS pId,
      p.PROCESS_INSTANCE_ID        AS "processInstanceId",
      p.EXECUTION_ID               AS "processExecutionId",
      p.DESCRIPTION                AS "processDescription",
      p.PARENT_PROCESS_INSTANCE_ID AS "parentProcessInstanceId",
      p.PROCESS_DEF_ID             AS "processDefId",
      p.NAME                       AS "processName",
      p.TYPE                       AS "processType",
      p.PATHWAY_LOCATION           AS "processPathwayLocation",
      p.START_TIME                 AS "processStartTime",
      p.END_TIME                   AS "processEndTime",
      p.INITIATOR_ID               AS "processInitiator",
      p.STATUS                     AS "processStatus",
      p.IS_ASYNC                   AS "isAsyncProcess",
      p.IS_DETACHED                AS "isDetachedProcess",
      p.CREATED_DATE               AS "processCreatedTime",
      p.JA_ID                      AS PJA_ID,
      p.SR_ID					   AS sr_id,
      -- Task
      NULL AS "tId",
      NULL AS "taskInstanceId",
      NULL AS "parentTaskInstanceId",
      NULL AS "taskDefKey",
      NULL AS "taskExecutionId",
      NULL AS "taskName",
      NULL AS "taskAltName",
      NULL AS "taskAssignee",
      NULL AS "taskClaimTime",
      NULL AS "taskExternalClaim",
      NULL AS "taskCompletedTime",
      NULL AS "taskDue",
      NULL AS "taskCategoryName",
      NULL AS "taskAction",
      NULL AS "taskStatus",
      NULL AS "queryStatus",
      NULL AS "taskCreatedTime",
      NULL AS "abortedBy",
      NULL AS "qualityStatus",
      NULL AS "sentToReviewBy",
      NULL AS "taskInitialLaunchTime",
      NULL AS "userLocation",
	  NULL AS "siteResponsible",
      NULL AS TJA_ID,
      -- classification task
      NULL AS ctId,
      NULL AS "classifier",
      NULL AS "classificationIsActive",
      NULL AS "classificationIsCriminal",
      NULL AS "classificationIteration",
      NULL AS "classificationClaimedBy",
      NULL AS "classificationSummarizer",
      NULL AS "classificationCategoryName",
      NULL AS "classificationTopicData",
      NULL AS "classificationCreatedDate",
      -- att suggestion task
      NULL AS astId,
	  NULL AS "suggestionId",
      NULL AS "suggestionTerm",
      NULL AS "suggestionComment",
      NULL AS "suggestionAttributeName",
      NULL AS "suggestedBy",
      NULL AS "suggestionActiveStatus",
      NULL AS "suggestionCreatedDate",
      -- query task
      NULL AS "qtId",
      NULL AS "queryAssignedToGroup",
      NULL AS "queryRequestor",
      NULL AS "queryResponder",
      NULL AS "queryQuestionCategory",
      NULL AS "queryQuestionText",
      NULL AS "queryAnswer",
      NULL AS "queryDetail",
      NULL AS "queryAction",
      -- duplicate review task
      NULL AS "drtId",
      NULL AS "duplicateCount",
      NULL AS "duplicateList",
      NULL AS "duplicateReviewerComment",
      NULL AS "duplicateAction",
      -- attribute task
      NULL AS "atId",
      NULL AS "topicalAreasRemaining",
      NULL AS "topicalAreaHnCounts",
      NULL AS "topicalAreasAi",
      NULL AS "atIsOrphan",
	  NULL AS "sentToAttributeReviewBy",
      --issue
      NULL  AS "issueId",
      NULL AS "issueTaskInstanceId",
      NULL AS "issueServiceId",
      NULL AS "issueCode",
      NULL AS "issueCategory",
      NULL AS "issueText",
      --service request
      sr.ID           AS "serviceRequestId",
      sr.CORRELATION_ID     AS "correlationId",
      sr.BATCH_ID           AS "serviceRequestBatchId",
      sr.SERVICE_ID         AS "serviceRequestServiceId",
      sr.PROCESS_ID         AS "serviceRequestProcessId",
      sr.STAGE_IDENTIFIER   AS "serviceStageIdentifier",
      sr.SERVICE_START_TIME AS "serviceStartTime",
      sr.SERVICE_END_TIME   AS "serviceEndTime",
      sr.STATUS_CODE        AS "serviceRequestStatusCode",
      sr.CREATED_DATE       AS "serviceCreatedDate",
      sr.WESTLAW_TIME       AS "serviceWestLawTime"
    FROM process_context pc
    JOIN process p
    ON pc.process_context_id = p.process_context_id
    LEFT JOIN judicial_artifact ja
    ON p.ja_id = ja.id
    LEFT JOIN service_request sr
    ON p.sr_id = sr.id
    LEFT JOIN source_artifact sa
    ON pc.process_context_id = sa.process_context_id
    LEFT JOIN docket_info di
    ON pc.process_context_id = di.process_context_id
    LEFT JOIN change_event ce
    ON pc.process_context_id             = ce.process_context_id
    WHERE COALESCE(pc.is_archived, 'N') <> 'Y'
    ) R1;
  /
  
  CREATE OR REPLACE SYNONYM JDGWORKFLOW_USER.V_GLOBAL_SEARCH_ISSUE FOR JDGWORKFLOWAPP.V_GLOBAL_SEARCH_ISSUE;
  GRANT
  SELECT ON JDGWORKFLOWAPP.V_GLOBAL_SEARCH_ISSUE TO JDGWORKFLOW_USER;
  /
 
  COMMIT;