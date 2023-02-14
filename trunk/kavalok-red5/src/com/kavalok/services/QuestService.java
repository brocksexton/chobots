package com.kavalok.services;

import java.util.ArrayList;
import java.util.List;

import com.kavalok.dao.QuestDAO;
import com.kavalok.dao.ServerDAO;
import com.kavalok.db.Quest;
import com.kavalok.db.Server;
import com.kavalok.dto.admin.QuestTO;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.xmlrpc.RemoteClient;

public class QuestService extends DataServiceNotTransactionBase {

	private static final String LOAD_COMMAND_NAME = "LoadQuestCommand";
	private static final String UNLOAD_COMMAND_NAME = "UnloadQuestCommand";

	public List<QuestTO> getQuests() {
		
		List<Quest> quests = new QuestDAO(getSession()).findAll();
		List<QuestTO> result = new ArrayList<QuestTO>();
		
		for(Quest quest : quests) {
			result.add(new QuestTO(quest));
		}

		return result;
	}

	public void saveQuest(QuestTO questTO) {

		ServerDAO serverDAO = new ServerDAO(getSession());
		QuestDAO questDAO = new QuestDAO(getSession());
		Quest quest = questDAO.findById(questTO.getId());
		List<Server> servers = new ArrayList<Server>();

		if (questTO.getServerId() >= 0) {
			Server server = serverDAO.findById(questTO.getServerId()); 
			quest.setServer(server);
			servers.add(server);
		} else {
			quest.setServer(null);
			servers = serverDAO.findAvailable();
		}

		quest.setEnabled(questTO.getEnabled());
		questDAO.makePersistent(quest);

		String commandName = (questTO.getEnabled()) ? LOAD_COMMAND_NAME
				: UNLOAD_COMMAND_NAME;
		
		for (Server server : servers) {
			new RemoteClient(server).sendCommand(commandName, quest.getName());
		}
		
	}
}
