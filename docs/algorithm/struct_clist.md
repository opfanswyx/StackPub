## clist.h
```c
#ifndef _CLIST_H_
#define _CLIST_H_
struct Node;
typedef struct Head* pHead;
typedef struct Node* pNode;

struct Head
{
	int length;
	pNode next;
};

struct Node
{
	int data;
	pNode next;
};
pHead ClistCreate();
int getLength(pHead ph);
int IsEmpty(pHead ph);
int ClistInsert(pHead ph,int pos,int val);
void print(pHead ph);
#endif
```
## clist.c
```c
#include "clist.h"
#include<stdio.h>
#include<stdlib.h>
pHead ClistCreate()
{
	pHead ph=(pHead)malloc(sizeof(struct Head));
	if(ph==NULL)
	{
		printf("malloc error\n");
	}
	ph->length=0;
	ph->next=NULL;
	return ph;
}
int IsEmpty(pHead ph)
{
	if(ph==NULL)
	{
		printf("error\n");
	}
	if(ph->length==0)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
int ClistInsert(pHead ph,int pos,int val)
{
	if(ph==NULL || pos<0 || pos>ph->length)
	{
		printf("error\n");
	}
	pNode pval=NULL;
	pval=(pNode)malloc(sizeof(struct Node));
	pval->data=val;
	if(IsEmpty(ph))
	{
		ph->next=pval;
		pval->next=pval;	//将第一个结点执行它自己
	}
	else
	{
		pNode pRear=ph->next;
		if(pos==0)				//在头结点后插入
		{
			while(pRear->next!=ph->next)	//在0号位置插入，需要先找到尾结点位置
			{
				pRear=pRear->next;
			}
			pval->next=ph->next;
			ph->next=pval;
			pRear->next=pval;	//这三个步骤不能改
		}
		else
		{
			pNode pCur=ph->next;
			int i;
			for(i=1;i<pos;i++)
			{
				pCur=pCur->next;
			}
			pval->next=pCur->next;
			pCur->next=pval;
		}
	}
	ph->length++;
	return 1;
}
void print(pHead ph)
{
	if(ph==NULL || ph->length==0)
	{
		printf("error\n");
	}
	pNode pTmp=ph->next;
	int i;
	for(i=0;i<ph->length;i++)
	{
		printf("%d ",pTmp->data);
		pTmp=pTmp->next;
	}
	printf("\n");
}

```
## main.c
```c
#define _CRT_SECURE_NO_WARNINGS
#include "clist.h"
#include<stdio.h>
#include<stdlib.h>
int main()
{
	int m,n;
	printf("please input cirle total num:\n");
	scanf("%d",&m);
	if(m<=0)
	{
		printf("please input correct number\n");
		return 0;
	}
	printf("please input goto out num:\n");
	scanf("%d",&n);
	if(n<=0)
	{
		printf("please input correct number\n");
		return 0;
	}
	pHead ph=NULL;
	ph=ClistCreate();
	if(ph==NULL)
	{
		printf("ClistCreate faild\n");
		return 0;
	}
	int i;
	for(i=m;i>0;i--)
	{
		ClistInsert(ph,0,i);
	}
	print(ph);
	printf("out number:\n");
	pNode node=ph->next;
	while(node->next!=node)		//循环结束条件，结点指向其自身，此时剩余最后一个结点
	{
		int j;
		for(j=1;j<n-1;j++)		//j<n-1,报到n就重新开始
		{
			node=node->next;
		}
		pNode pTmp=node->next;	//pTmp指向要出局的结点

		//接下来先要判断这个结点是0号位置的结点还是其它位置的结点
		if(pTmp==ph->next) 	//如果此结点在0号位置
		{
			ph->next=pTmp->next;
			node->next=pTmp->next;
			printf("%d ",pTmp->data);
			free(pTmp);
			ph->length--;
		}
		else
		{
			node->next=pTmp->next;
			printf("%d ",pTmp->data);
			free(pTmp);
			ph->length--;
		}
		node=node->next;
	}
	node->next=node;
	printf("\n");
	printf("last num:\n");
	print(ph);
	system("pause");
	return 0;
}

```