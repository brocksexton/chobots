package org.red5.server.net.rtmp;

/*
 * RED5 Open Source Flash Server - http://www.osflash.org/red5
 * 
 * Copyright (c) 2006-2007 by respective authors (see below). All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software 
 * Foundation; either version 2.1 of the License, or (at your option) any later 
 * version. 
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License along 
 * with this library; if not, write to the Free Software Foundation, Inc., 
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
 */

import org.red5.server.api.stream.IClientStream;
import org.red5.server.net.rtmp.event.IRTMPEvent;
import org.red5.server.net.rtmp.event.Invoke;
import org.red5.server.net.rtmp.event.Notify;
import org.red5.server.net.rtmp.message.Header;
import org.red5.server.net.rtmp.message.Packet;
import org.red5.server.net.rtmp.status.Status;
import org.red5.server.net.rtmp.status.StatusCodes;
import org.red5.server.service.Call;
import org.red5.server.service.PendingCall;
import org.red5.threadmonitoring.ThreadMonitorServices;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Identified connection that transfers packets.
 */
public class Channel {
  /**
   * Logger
   */
  protected static Logger log = LoggerFactory.getLogger(Channel.class);

  /**
   * RTMP connection used to transfer packets.
   */
  private RTMPConnection connection;

  /**
   * Channel id
   */
  private int id;

  // private Stream stream;
  /**
   * Creates channel from connection and channel id
   * 
   * @param conn
   *          Connection
   * @param channelId
   *          Channel id
   */
  public Channel(RTMPConnection conn, int channelId) {
    connection = conn;
    id = channelId;
  }

  /**
   * Closes channel with this id on RTMP connection.
   */
  public void close() {
    connection.closeChannel(id);
  }

  /**
   * Getter for id.
   * 
   * @return Channel ID
   */
  public int getId() {
    return id;
  }

  /**
   * Getter for RTMP connection.
   * 
   * @return RTMP connection
   */
  protected RTMPConnection getConnection() {
    return connection;
  }

  /**
   * Writes packet from event data to RTMP connection.
   * 
   * @param event
   *          Event data
   */
  public void write(IRTMPEvent event) {
    ThreadMonitorServices.setJobDetails("Channel.write(IRTMPEvent event): " + event);
    final IClientStream stream = connection.getStreamByChannelId(id);
    if (id > 3 && stream == null) {
      log.info("Stream doesn't exist any longer, discarding message " + event);
      return;
    }

    final int streamId = (stream == null) ? 0 : stream.getStreamId();
    write(event, streamId);
  }

  /**
   * Writes packet from event data to RTMP connection and stream id.
   * 
   * @param event
   *          Event data
   * @param streamId
   *          Stream id
   */
  private void write(IRTMPEvent event, int streamId) {
    ThreadMonitorServices.startJobSubDetails();
    ThreadMonitorServices.setJobDetails("Channel.write(IRTMPEvent event, int streamId) event: {0} streamId: {1}", event, streamId);
    final Header header = new Header();
    final Packet packet = new Packet(header, event);

    header.setChannelId(id);
    header.setTimer(event.getTimestamp());
    header.setStreamId(streamId);
    header.setDataType(event.getDataType());
    if (event.getHeader() != null) {
      header.setTimerRelative(event.getHeader().isTimerRelative());
    }

    // should use RTMPConnection specific method..
    // System.out.println("packet.getHeader() " + packet.getHeader());
    // System.out.println("packet.getMessage() " + packet.getMessage() + "
    // \n");

    // try {
    // if (packet.getMessage().toString().indexOf("L, M") >= 0){
    // System.err.println("send message arguments: " + packet.getMessage());
    // System.err.println("Thread.currentThread().getId(): " +
    // Thread.currentThread().getId() + "\n");
    // Thread.sleep(10000);
    // }
    // } catch (InterruptedException e) {
    // // TODO Auto-generated catch block
    // e.printStackTrace();
    // }

    if (connection.isConnected()) {

      long now = System.currentTimeMillis();
      if (packet.getHeader().getSize() > 8192) {
        System.err.println("Big message size: " + packet.getHeader().getSize() + " client host: "
            + connection.getRemoteAddress() + " Message: " + packet.getMessage());
        ThreadMonitorServices.setJobDetails("Big message size: " + packet.getHeader().getSize() + " client host: "
            + connection.getRemoteAddress() + " Message: " + packet.getMessage());
      }
      connection.write(packet);
      long time = System.currentTimeMillis() - now;
      if (time > 2000) {
        System.err.println("SLOW channel write time: " + (time) + " client host: " + connection.getRemoteAddress()
            + "\nMessage: " + packet.getMessage());
      }
    }

    ThreadMonitorServices.stopJobSubDetails("Channel.write(IRTMPEvent event, int streamId) event: {0} streamId: {1}", event, streamId);
  }

  /**
   * Sends status notification.
   * 
   * @param status
   *          Status
   */
  public void sendStatus(Status status) {
    final boolean andReturn = !status.getCode().equals(StatusCodes.NS_DATA_START);
    final Invoke invoke;
    if (andReturn) {
      final PendingCall call = new PendingCall(null, "onStatus", new Object[] { status });
      invoke = new Invoke();
      invoke.setInvokeId(1);
      invoke.setCall(call);
    } else {
      final Call call = new Call(null, "onStatus", new Object[] { status });
      invoke = (Invoke) new Notify();
      invoke.setInvokeId(1);
      invoke.setCall(call);
    }
    // We send directly to the corresponding stream as for
    // some status codes, no stream has been created and thus
    // "getStreamByChannelId" will fail.
    write(invoke, connection.getStreamIdForChannel(id));
  }

}
