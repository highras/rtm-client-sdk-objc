#include "AdvanceAnswer.h"
#include "IQuestProcessor.h"
#include "ITaskThreadPool.h"
#include <thread>

using namespace fpnn;
extern pthread_key_t AnswerStatusKey;

struct AnswerStatus
{
	bool _answered;
	FPQuestPtr _quest;
	ConnectionInfoPtr _connInfo;

	AnswerStatus(ConnectionInfoPtr connInfo, FPQuestPtr quest): _answered(false), _quest(quest), _connInfo(connInfo) {}
	~AnswerStatus() 
	{
		std::cout<<"~AnswerStatus FPQuestPtr cout:"<<_quest.use_count()<<",ConnectionInfoPtr count:"<<_connInfo.use_count()<<std::endl;
	}
};
// static thread_local std::unique_ptr<AnswerStatus> gtl_answerStatus;
struct AnswerStatus * getAnswerStatus()
{
	return (struct AnswerStatus*)pthread_getspecific(AnswerStatusKey);
}

void IQuestProcessor::initAnswerStatus(ConnectionInfoPtr connInfo, FPQuestPtr quest)
{
	struct AnswerStatus *status = getAnswerStatus();
	if (status)
	{
		status->_answered = false;
		status->_quest = quest;
		status->_connInfo = connInfo;
	}
	else
	{
		struct AnswerStatus *Answer_gloable = new AnswerStatus(connInfo, quest);
		int ret = pthread_setspecific(AnswerStatusKey, Answer_gloable);
		if (ret != 0 )
			LOG_ERROR("pthread_setspecific create error ret: %d", ret);
	}
}

bool IQuestProcessor::getQuestAnsweredStatus()
{
	struct AnswerStatus *status = getAnswerStatus();
	if (status)
		return status->_answered;
	else
		LOG_ERROR("getQuestAnsweredStatus getAnswerStatus() is null");

	return false;
}

bool IQuestProcessor::finishAnswerStatus()
{
	bool status(false);
	struct AnswerStatus *anstatus = getAnswerStatus();
	if (anstatus)
	{
		status = anstatus->_answered;
		anstatus->_quest = nullptr;
		anstatus->_connInfo = nullptr;
	}
	else{
		LOG_ERROR("finishAnswerStatus getAnswerStatus() is null");
	}
	return status;
}

bool IQuestProcessor::sendAnswer(FPAnswerPtr answer)
{
	struct AnswerStatus *status = getAnswerStatus();
	if (!answer || !status)
		return false;

	if (status->_answered)
		return false;

	if (!status->_quest->isTwoWay())
		return false;

	std::string* raw = answer->raw();

	ConnectionInfoPtr connInfo = status->_connInfo;
	_concurrentSender->sendData(connInfo->socket, connInfo->token, raw);
	status->_answered = true;
	return true;
}

IAsyncAnswerPtr IQuestProcessor::genAsyncAnswer()
{
	struct AnswerStatus *status = getAnswerStatus();
	if (!status)
		return nullptr;

	if (status->_answered)
		return nullptr;

	if (status->_quest->isOneWay())
		return nullptr;

	IAsyncAnswerPtr async(new AsyncAnswerImp(_concurrentSender, status->_connInfo, status->_quest));
	status->_answered = true;
	return async;
}
