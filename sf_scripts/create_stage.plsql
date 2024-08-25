-- Creating the Storage Integration and Role for accessing Google Cloud Storage
use schema wvcode_db.public;

create
or replace storage integration wvcode_gcs type = external_stage storage_provider = 'GCS' enabled = true storage_allowed_locations = ('gcs://wvcode_gcs/');

-- this step is used to get the service account
describe storage integration wvcode_gcs;

create role wvcode_gcs_role;

grant create stage on schema wvcode_db.public to role wvcode_gcs_role;

grant usage on integration wvcode_gcs to role wvcode_gcs_role;

create
or replace file format wvcode_csv type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"';

create
or replace file format wvcode_csv_0 type = csv field_delimiter = ',' parse_header = true FIELD_OPTIONALLY_ENCLOSED_BY = '"';

create stage wvcode_stage url = 'gcs://wvcode_gcs' storage_integration = wvcode_gcs file_format = wvcode_csv;

CREATE NOTIFICATION INTEGRATION wvcode_not TYPE = QUEUE NOTIFICATION_PROVIDER = GCP_PUBSUB ENABLED = true GCP_PUBSUB_SUBSCRIPTION_NAME = 'wvcode_sub';

-- After that, it is needed to make the configuration on google cloud console
-- to allow the access to the storage integration
-- Create a bucket with the name wvcode_gcs
-- Give permission to the bucket to the service account created by the storage
-- integration
-- The service account is the one that is shown in the description of the storage
-- integration
-- Create a pub/sub topic with the name wvcode_notifications
-- Create a subscription with the name wvcode_sub
-- Give permission to the subscription to the service account created by the storage
-- integration