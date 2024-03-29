{ Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 }

{
 * @package Virtual Host package
 }

{
 * called before any config is read
 * @param p Pool to allocate out of
 }
procedure ap_init_vhost_config(p: Papr_pool_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_init_vhost_config' + LibSuff4;

{
 * called after the config has been read to compile the tables needed to do 
 * the run-time vhost lookups
 * @param p The pool to allocate out of
 * @param main_server The start of the virtual host list
 * @deffunc ap_fini_vhost_config(apr_pool_t *p, server_rec *main_server)
 }
procedure ap_fini_vhost_config(p: Papr_pool_t; main_server: Pserver_rec);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_fini_vhost_config' + LibSuff8;

{
 * handle addresses in <VirtualHost> statement
 * @param p The pool to allocate out of
 * @param hostname The hostname in the VirtualHost statement
 * @param s The list of Virtual Hosts.
 }
//const AnsiChar *ap_parse_vhost_addrs(apr_pool_t *p, const AnsiChar *hostname, server_rec *s);

{
 * handle NameVirtualHost directive
 * @param cmd Command Parameters structure
 * @param dummy NOT USED
 * @param arg a host of the form "<address>[:port]"
 }
//const AnsiChar *ap_set_name_virtual_host (cmd_parms *cmd, void *dummy,
//				      const AnsiChar *arg);

{
 * Callback function for every Name Based Virtual Host.
 * @param baton Opaque user object
 * @param conn The current Connection
 * @param s The current Server
 * @see ap_vhost_iterate_given_conn
 * @return 0 on success, any non-zero return will stop the iteration.
 }
type
  ap_vhost_iterate_conn_cb = function (baton: Pointer; conn: Pconn_rec; s: Pserver_rec): Integer;

{
 * For every virtual host on this connection, call func_cb.
 * @param conn The current connection
 * @param func_cb Function called for every Name Based Virtual Host for this
 *                connection.
 * @param baton Opaque object passed to func_cb.
 * @return The return value from func_cb.
 * @note If func_cb returns non-zero, the function will return at this point,
 *       and not continue iterating the virtual hosts.
 }
function ap_vhost_iterate_given_conn(conn: Pconn_rec;
 func_cb: ap_vhost_iterate_conn_cb; baton: Pointer): Integer;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_vhost_iterate_given_conn' + LibSuff12;

{
 * given an ip address only, give our best guess as to what vhost it is 
 * @param conn The current connection
 }
procedure ap_update_vhost_given_ip(conn: Pconn_rec);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_update_vhost_given_ip' + LibSuff4;

{
 * ap_update_vhost_given_ip is never enough, and this is always called after 
 * the headers have been read.  It may change r->server.
 * @param r The current request
 }
procedure ap_update_vhost_from_headers(r: Prequest_rec);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_update_vhost_from_headers' + LibSuff4;

{
 * Match the host in the header with the hostname of the server for this
 * request.
 * @param r The current request
 * @param host The hostname in the headers
 * @param port The port from the headers
 * @return return 1 if the host:port matches any of the aliases of r->server,
 * return 0 otherwise
 * @deffunc int ap_matches_request_vhost(request_rec *r, const AnsiChar *host, apr_port_t port)
 }
function ap_matches_request_vhost(r: Prequest_rec; const host: PAnsiChar;
 port: apr_port_t): Integer;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_matches_request_vhost' + LibSuff12;

